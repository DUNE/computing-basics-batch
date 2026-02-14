  #!/usr/bin/env python3 
  #
  # Convert protoDUNE metadata from extractor_prod.py into JSON suitable to be 
  # the value of the "metadata" key in the JSON sent to MetaCat
  #
  # THIS IS NOT REALLY PART OF justIN AND IT SHOULD BE INCORPORATED INTO THE 
  # SCRIPTS ASSOCIATED WITH APPLICATIONS, LIKE extractor_prod.py !
  #
  # Adapted from 
  # https://github.com/ivmfnal/protodune/blob/main/tools/declare_meta.py and
  # https://github.com/ivmfnal/protodune/blob/main/declad/mover.py
  # to write out modified JSON rather than uploading it. This allows the script
  # to be run inside jobscripts supplied by users.
  #
  # A version can be found in the jobutils area of the justIN UPS product
  # in cvmfs
  #

import sys, json
import datetime
import argparse

def getCoreAttribute():
  coreAttributes = {
      "event_count":  "core.event_count",
      "file_type"  :  "core.file_type", 
      "file_format":  "core.file_format",
      "data_tier"  :  "core.data_tier", 
      "data_stream":  "core.data_stream", 
      "events"     :  "core.events",
      "first_event":  "core.first_event_number",
      "last_event" :  "core.last_event_number",
      "event_count":  "core.event_count",
      "user"       :  None,
      "group"      :  None
  }
  return coreAttributes

def doit(inputMetadataFile, allInputDidsFile=None, namespace="usertests", outputFormat=None, outputTier=None ):  
  coreAttributes = getCoreAttribute()

  try:
    inputMetadata = json.load(open(inputMetadataFile, "r"))
  except Exception as e:
    print("Error reading metadata from file: " + str(e), file=sys.stderr)
    sys.exit(1)

  allInputDids = []
  if allInputDidsFile is not None:
    try:
      for line in open(allInputDidsFile, "r").read().splitlines(): 
        allInputDids.append(line) 
    except Exception as e:
      print("Error read all input DIDs file: " + str(e), file=sys.stderr)
      sys.exit(2)
  

  inputMetadata.pop("file_size", None)
  inputMetadata.pop("checksum", None)
  inputMetadata.pop("file_name", None)

  

  # Most of the metadata goes in "metadata" within the outer dictionary
  outputMetadata = { "metadata": {}}

  runsSubruns = set()
  runType = None
  runs = set()
  for run, subrun, rtype in inputMetadata.pop("runs", []):
    runType = rtype
    runs.add(run)
    runsSubruns.add(100000 * run + subrun)

  outputMetadata["metadata"]["core.runs_subruns"] = sorted(list(runsSubruns))
  outputMetadata["metadata"]["core.runs"] = sorted(list(runs))
  outputMetadata["metadata"]["core.run_type"] = runType

  app = inputMetadata.pop("application", None)
  if app:
    if "name" in app:    
      outputMetadata["metadata"]["core.application.name"] = app["name"]
    if "version" in app: 
      outputMetadata["metadata"]["core.application.version"] = app["version"]
    if "family" in app:  
      outputMetadata["metadata"]["core.application.family"] = app["family"]
    if "family" in app and "name" in app:
      outputMetadata["metadata"]["core.application"] = \
        app["family"] + "." + app["name"]

  for k in ("start_time", "end_time"):
    t = inputMetadata.pop(k, None)
    if t is not None:
      t = datetime.datetime.fromisoformat(t).replace(
                                  tzinfo=datetime.timezone.utc).timestamp()
      outputMetadata["metadata"]["core." + k] = t

  for name, value in inputMetadata.items():
    
    
    if name == 'parents': 
      parentDids = []
      for parent in value:
        matchingDid = None
        for did in allInputDids:
          if did.endswith(parent["file_name"]):
            matchingDid = did
            break
        name = did.split(':')[1]
        namespace = did.split(':')[0]
        if name != 'noparents.root':
          outputMetadata["parents"] = [      
          {"name": name,
            "namespace": namespace
          }
        ]	  

  #      if matchingDid:
  #        parentDids.append({ "did" : matchingDid })
  #      else:
  #        print("No matching input DID for file %s with parent file_name %s- exiting" 
  #              % (str(parent), str(parent["file_name"])),
  #              file=sys.stderr)
  #        sys.exit(3)
      
      # Add the list of { "did": "..." } dictionaries to top level
      


  #    outputMetadata["parents"] = parentDids 

      
        
    else:
      if '.' in name:
        outputMetadata["metadata"][name] = value
      else:
        if name in coreAttributes:
          if coreAttributes[name]:
            outputMetadata["metadata"][coreAttributes[name]] = value
        else:
          outputMetadata["metadata"]['x.' + name] = value
      print ("setting " + name + " to " + str(value))

# patches added by HMS to make this more general
  if namespace != None:
    outputMetadata['namespace'] = namespace
    print ("overriding namespace to " + namespace, file=sys.stdout)
    
# add the parentage if not inherited
  if allInputDidsFile is not None and outputMetadata.get("parents", None) is None:
    parentDids = []
    for line in open(allInputDidsFile, "r").read().splitlines(): 
      ns = line.split(':')[0]
      name = line.split(':')[1]
      parentDids.append({ "name" : name, "namespace": ns }) 
    outputMetadata["parents"] = parentDids

  if outputFormat != None:
    outputMetadata["metadata"]["core.file_format"] = outputFormat
    print ("overriding output format to " + outputFormat, file=sys.stdout)

  if outputTier != None:
    outputMetadata["metadata"]["core.data_tier"] = outputTier
    print ("overriding output data_tier to " + outputTier, file=sys.stdout)

      
  outputMetadata["metadata"].setdefault("core.event_count", 
                  len(outputMetadata["metadata"].get("core.events", [])))
      
  
  json.dump(outputMetadata, sys.stdout, indent=4, sort_keys=True)
  
  outname = inputMetadataFile.replace(".ext.json",".json")
  with open(outname, "w") as f:
    json.dump(outputMetadata, f, indent=4, sort_keys=True)

if __name__ == "__main__":
  parser = argparse.ArgumentParser(
  description='Command line interface for merge_utils')
  
  parser.add_argument('--inputMetadataFile', type=str, help='Path to the input metadata JSON file')
  
  parser.add_argument('--namespace', type=str, help='Namespace to use for the metadata', default="usertests")
  parser.add_argument('--outputFormat', type=str, default=None, 
                      help='Output format (default: inherits from input)')
  parser.add_argument('--outputTier', default=None,  help='Output data tier (default: inherits)')
  parser.add_argument('--InputDidsFile', type=str, default=None, 
                      help='Optional path to a file containing all input DIDs, one per line')
  args = parser.parse_args()
  doit(inputMetadataFile=args.inputMetadataFile,
       allInputDidsFile=args.allInputDidsFile,
       namespace=args.namespace, 
       outputFormat=args.outputFormat,
       outputTier=args.outputTier)