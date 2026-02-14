"""Check metadata against a template"""
import os,sys,json

DEBUG=False

def TypeChecker(filemd=None, errfile=None, verbose=False):
    " check for type and missing required fields in metadata"

    # define types
    valuetypes = {
    "STRING" : type(""),
    "FLOAT" : type(1.0),
    "INT" : type(1),
    "LIST" : type([]),
    "DICT" : type({}),
    }

    # read in the defaults

    f = open("DUNEmdSpec.json",'r')
    config = json.load(f)
    f.close()

    # list defaults for metadata fields
    
    

    # set default values for fields that are often missing but needed
    fixDefaults = {
        "core.file_content_status":"good",
        "retention.status":"active",
        "retention.class":"unknown"
    }
    
    # place to put optional fields: all is optional for all, otherwise you need to tell it data_tier

    optional = { 
        "all":["core.events","dune.daq_test"],
        "root-tuple":["core.event_count","core.first_event_number","core.last_event_number"],
        "raw":["dune.config_file", "dune_mc.gen_fcl_filename","dune_mc.geometry_version","core.application.family","core.application.name","core.application.version"],
        "binary-raw":["dune.config_file", "dune_mc.gen_fcl_filename","dune_mc.geometry_version","core.application.family","core.application.name","core.application.version"],
        "trigprim":["dune.config_file", "dune_mc.gen_fcl_filename","dune_mc.geometry_version","core.application.family","core.application.name","core.application.version"],
        "root-tuple-virtual":["core.event_count","core.first_event_number","core.last_event_number"]
        }

   
    did = filemd["namespace"]+":"+filemd["name"]

    # do this as file may not have an fid yet, but fid makes shorter error messages. 
    if "fid" in filemd:
        fid = filemd["fid"]
    else:
        fid = did

    # start out with valid and no fixes needed    
    valid = True
    fixes = {}

    # loop over default md keys

    for x, xtype in config["basetypes"].items():
        if DEBUG: print (x,xtype)
        if x in optional["all"]: continue
        # check required
        if x not in filemd.keys():
            error = x+" is missing from "+ fid + "\n"
            print (error)
            if errfile is not None: errfile.write(error)
            valid *= False
            print (filemd.keys())         
                
        # check type
        if x != "metadata" and valuetypes[xtype] != type(filemd[x]) :
            #print (x,xtype)
            if xtype == valuetypes["FLOAT"] and type(filemd[x]) == valuetypes["INT"]: continue
            error = "top level item %s has wrong type in %s \n"%(x,fid)
            print (error)
            if errfile is not None: errfile.write(error)
            valid *= False

    # now do the metadata
    if DEBUG:
        print ("keys",filemd.keys())

    if "metadata" not in filemd.keys():
        print ("strange - no metadata for this file")
        
    md = filemd["metadata"]
    
    for x, xtype in config["basetypes"]["metadata"].items():
        if DEBUG: print ("checking", x,xtype)
        if x in optional["all"]: continue # skip optional items
        if "core.run_type" in md and md["core.run_type"] != "mc" and "mc" in x: 
            if verbose: print ("skipping mc only",x)
            continue

        # check required keys
        if x not in md.keys():
            if "core.data_tier" in md and md["core.data_tier"] in optional and x in optional[md["core.data_tier"]]:  # skip optional items by data_tier
                 
                if verbose: print ("skipping optional missing field for data_tier",md["core.data_tier"],x)
                continue
            error = x+ " is missing from " + fid + "\n"
            print (error)
            if errfile is not None: errfile.write(error)
            valid *= False
            if x in fixDefaults:
                fixes[x]=fixDefaults[x]
            continue
        # check for type
        if DEBUG: print ("xtype",xtype)
        if valuetypes[xtype] != type(md[x]):
            if xtype == "FLOAT" and type(md[x]) == valuetypes["INT"]: continue
            error =  "%s has wrong type in %s\n "%(x,fid)
            print (error)
            if errfile is not None: errfile.write(error+"\n")
            valid *= False
    for x,core in config["known_fields"].items():
        if x not in md: 
            print ("required field",x,"not present")
            valid *=False  
            continue
        if md[x] not in core:
            print ("unknown required metadata field",x,"=",md[x])
            valid *= False
    if not valid:
        print (did, " fails basic metadata tests")
        if len(fixes) !=0:
            print ("you could fix this by applying this fix")
            print (json.dumps(fixes,indent=4))
    
    # look for upper case in keys

    for x,v in md.items():
        if x != x.lower():
            print ("OOPS upper case",x)
            
            
            

            
    return valid, fixes


if __name__ == '__main__':

    if len(sys.argv) < 2:
        print ("please provide a json file to check")
        sys.exit(1)
    jsonname = sys.argv[1]
    if not os.path.exists(jsonname):
        print ("input file does not exist",jsonname)
        sys.exit(1)
    jsonfile = open(jsonname,'r')
    filemd = json.load(jsonfile)
    errfile = open(jsonname+".err",'w')
    status,fixes = TypeChecker(filemd=filemd,errfile=errfile,verbose=True)
    errfile.close()