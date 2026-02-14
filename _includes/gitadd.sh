git add *.sh *.py setup-grid DUNE*json
tar cBf - \
extractor_new.py \
gitadd.sh \
job_config.sh \
makercds.sh \
maketar.sh \
setup_before_submit.sh \
submit_local_code.jobscript.sh \
setup-grid \
submit_workflow.sh \
> ../files/usefulcode.tar
git add ../files/usefulcode.tar
git add ../_extras/short_submission.md
