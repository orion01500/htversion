# htversion

htversion is a site versioning system which aims to detect changes to sites. The goal of this project is to force some transparency onto government and to protect content that may end up as legal evidence from deletion.

The functionality that this project provides is similar to The Internet Archiver's Wayback Machine. While, the Wayback Machine takes entiresnapshots of sites, including images, htversion only tracks text content. This includes HTML, CSS, Javascript and other text-based documents.

An advantage that htversion has over the Wayback Machine is its use of a code revision system to track modifications. This enables htversion to return more accurate and specific detail.

Git was selected because the goal was to upload each tracked site onto github under the [projects directory](projects). Github's API implementation and freemium policy allows us to automate and make access to these "change logs" more acceessible and transparent to the public.

## Background

This project came about when it was discovered that the Sarawak state government was actively denying certain crawlers from crawling and archiving sites within the subdomain .sarawak.gov.my. For example, [snapshots of the Ministry of Local Government and Housing](https://web.archive.org/web/*/http://www.mlgh.sarawak.gov.my/modules/web/index.php) no longer appears on the Wayback Machine.

The reason for blocking the archival of these sites is not known at this time. Protecting copyrighted content does not seem to be one of the motives as other crawlers like Google are allowed access. The servers seem to be able to throttle and rate limit excessiveconnections so bandwidth contraints do not seem like a plausible reason either.

However, what is certain is that the task of identifying what and when content from these sites were changed is now more challanging.

## Testing

Unfortunately, the code has not been through extensive testing so expect some surprises.

## Deployment

I wouldn't deploy this project into production just yet. More testing is required.

## Future Work

The following are outstanding TODOs

1. track PDF files for changes
2. Handle various exceptions/status codes better
3. Switch to python instead of bash?

## More Info

Drop me a line if what you wish to do is listed below

- you want to complain
- you have an idea that will improve the project
- you have an idea that will kill the project
- you want to contribute to the project
