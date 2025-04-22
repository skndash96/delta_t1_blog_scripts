* * * * * root /scripts/bin/notifs_checker_cron >> /scripts/notifs_checker_cron.log 2>&1
14 15 * 2,5,8,11 4,6 root /scripts/bin/schedule_reports_filter && /scripts/bin/gen_report
