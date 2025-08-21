# Renaming multiple files with a text editor

This script creates a list of the files to be renamed, which can then be edited with an arbitrary text editor. When the script is run again, the files are renamed accordingly. Name collisions are detected in advance. Swapping file names is possible. The path to a text editor can be specified in the script, which causes the list to open automatically.

### Usage

`edit-filenames.sh [FILE ...]`

If no files are specified, every file in the working directory is added to the list.

### Example

```console
user@linux:~/Harvest$ ls -l
total 42468
-rw-rw-r-- 1 user user 4948985 Nov 23  2023 '01 - Out on the Weekend.flac'
-rw-rw-r-- 1 user user 3282680 Nov 24  2023 '02 - Harvest.flac'
-rw-rw-r-- 1 user user 4122188 Nov 12  2023 '03 - A Man Needs a Maid.flac'
-rw-rw-r-- 1 user user 3294237 Jan 21  2024 '04 - Heart of Gold.flac'
-rw-rw-r-- 1 user user 3341207 Nov 26  2023 '05 - Are You Ready for the Country.flac'
-rw-rw-r-- 1 user user 3621472 Jan 21  2024 '06 - Old Man.flac'
-rw-rw-r-- 1 user user 2970194 Nov 26  2023 "07 - There's a World.flac"
-rw-rw-r-- 1 user user 3890767 Nov 18  2023 '08 - Alabama.flac'
-rw-rw-r-- 1 user user 2103142 Nov  3  2023 '09 - The Needle and the Damage Done.flac'
-rw-rw-r-- 1 user user 6667208 Nov 18  2023 '10 - Words (Between the Lines of Age).flac'
-rw-rw-r-- 1 user user 4916016 Mär 24  2024  Booklet.pdf
-rw-rw-r-- 1 user user  301875 Mär 24  2024  Cover.jpg
user@linux:~/Harvest$ edit-filenames.sh *.flac
You can now edit the file names in ./edit_filenames, then run this
script again to rename the files (arguments will be ignored).
user@linux:~/Harvest$ cat ./edit_filenames
01 - Out on the Weekend.flac
02 - Harvest.flac
03 - A Man Needs a Maid.flac
04 - Heart of Gold.flac
05 - Are You Ready for the Country.flac
06 - Old Man.flac
07 - There's a World.flac
08 - Alabama.flac
09 - The Needle and the Damage Done.flac
10 - Words (Between the Lines of Age).flac
user@linux:~/Harvest$ vim ./edit_filenames     # edit file names with editor of choice
user@linux:~/Harvest$ edit-filenames.sh *.flac # run script again to rename files
Rename files? (yes/[no]) yes
user@linux:~/Harvest$
```
