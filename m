Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from merlin.infradead.org (merlin.infradead.org
 [IPv6:2001:8b0:10b:1231::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 753CD21E1DAD0
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 15:36:31 -0700 (PDT)
Subject: Re: [RFC 01/16] NOVA: Documentation
References: <150174646416.104003.14042713459553361884.stgit@hn>
 <150174649708.104003.4595004262958377346.stgit@hn>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3a34b099-8b3a-4c12-4f8e-afd5e3a42c32@infradead.org>
Date: Thu, 3 Aug 2017 15:38:30 -0700
MIME-Version: 1.0
In-Reply-To: <150174649708.104003.4595004262958377346.stgit@hn>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Steven Swanson <swanson@eng.ucsd.edu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Steven Swanson <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On 08/03/2017 12:48 AM, Steven Swanson wrote:
> A brief overview is in README.md.
> 

See below.

> Implementation and usage details are in Documentation/filesystems/nova.txt.
> 

Reviewed in a separate email.

> These two papers provide a detailed, high-level description of NOVA's design goals and approach:
> 
>    NOVA: A Log-structured File system for Hybrid Volatile/Non-volatile Main Memories (http://cseweb.ucsd.edu/~swanson/papers/FAST2016NOVA.pdf)
> 
>    Hardening the NOVA File System (http://cseweb.ucsd.edu/~swanson/papers/TechReport2017HardenedNOVA.pdf)
> 
> Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
> ---
>  Documentation/filesystems/00-INDEX |    2 
>  Documentation/filesystems/nova.txt |  771 ++++++++++++++++++++++++++++++++++++
>  MAINTAINERS                        |    8 
>  README.md                          |  173 ++++++++
>  4 files changed, 954 insertions(+)
>  create mode 100644 Documentation/filesystems/nova.txt
>  create mode 100644 README.md
> 

This file should not be in the top-level directory.
It would be OK in Documentation/filesystems, probably with a different
filename.

> diff --git a/README.md b/README.md
> new file mode 100644
> index 000000000000..4f778e99a79e
> --- /dev/null
> +++ b/README.md
> @@ -0,0 +1,173 @@
> +# NOVA: NOn-Volatile memory Accelerated log-structured file system
> +
> +NOVA's goal is to provide a high-performance, full-featured, production-ready
> +file system tailored for byte-addressable non-volatile memories (e.g., NVDIMMs
> +and Intel's soon-to-be-released 3DXpoint DIMMs).  It combines design elements
> +from many other file systems to provide a combination of high-performance,

                                                            high performance,

> +strong consistency guarantees, and comprehensive data protection.  NOVA support

                                                                           supports

> +DAX-style mmap and making DAX performs well is a first-order priority in NOVA's

                                 perform

> +design.  NOVA was developed by the [Non-Volatile Systems Laboratory][NVSL] in
> +the [Computer Science and Engineering Department][CSE] at the [University of
> +California, San Diego][UCSD].
> +
> +
> +NOVA is primarily a log-structured file system, but rather than maintain a
> +single global log for the entire file system, it maintains separate logs for
> +each file (inode).  NOVA breaks the logs into 4KB pages, they need not be

                                                     pages;

> +contiguous in memory.  The logs only contain metadata.
> +
> +File data pages reside outside the log, and log entries for write operations
> +point to data pages they modify.  File modification uses copy-on-write (COW) to
> +provide atomic file updates.
> +
> +For file operations that involve multiple inodes, NOVA use small, fixed-sized

                                                          uses

> +redo logs to atomically append log entries to the logs of the inodes involned.

                                                                        involved.

> +
> +This structure keeps logs small and make garbage collection very fast.  It also

                                       makes

> +enables enormous parallelism during recovery from an unclean unmount, since
> +threads can scan logs in parallel.
> +
> +NOVA replicates and checksums all metadata structures and protects file data
> +with RAID-4-style parity.  It supports checkpoints to facilitate backups.
> +
> +A more thorough discussion of NOVA's design is avaialable in these two papers:
> +
> +**NOVA: A Log-structured File system for Hybrid Volatile/Non-volatile Main Memories** 
> +[PDF](http://cseweb.ucsd.edu/~swanson/papers/FAST2016NOVA.pdf)<br>
> +*Jian Xu and Steven Swanson*<br>
> +Published in [FAST 2016][FAST2016]
> +
> +**Hardening the NOVA File System**
> +[PDF](http://cseweb.ucsd.edu/~swanson/papers/TechReport2017HardenedNOVA.pdf) <br>
> +UCSD-CSE Techreport CS2017-1018
> +*Jian Xu, Lu Zhang, Amirsaman Memaripour, Akshatha Gangadharaiah, Amit Borase, Tamires Brito Da Silva, Andy Rudoff, Steven Swanson*<br>
> +
> +Read on for further details about NOVA's overall design and its current status 
> +
> +### Compatibilty with Other File Systems
> +
> +NOVA aims to be compatible with other Linux file systems.  To help verify that it achieves this we run several test suites against NOVA each night.

Compatible in what ways?

> +
> +* The latest version of XFSTests. ([Current failures](https://github.com/NVSL/linux-nova/issues?q=is%3Aopen+is%3Aissue+label%3AXFSTests))
> +* The (Linux testing project)(https://linux-test-project.github.io/) file system tests.
> +* The (fstest POSIX test suite)[POSIXtest].
> +
> +Currently, nearly all of these tests pass for the `master` branch, and we have
> +run complex programs on NOVA.  There are, of course, many bugs left to fix.
> +
> +NOVA uses the standard PMEM kernel interfaces for accessing and managing
> +persistent memory.
> +
> +### Atomicity
> +
> +By default, NOVA makes all metadata and file data operations atomic.
> +
> +Strong atomicity guarantees make it easier to build reliable applications on
> +NOVA, and NOVA can provide these guarantees with sacrificing much performance

                                               without

> +because NVDIMMs support very fast random access.
> +
> +NOVA also supports "unsafe data" and "unsafe metadata" modes that
> +improve performance in some cases and allows for non-atomic updates of file

                                         allow

> +data and metadata, respectively.
> +
> +### Data Protection
> +
> +NOVA aims to protect data against both misdirected writes in the kernel (which
> +can easily "scribble" over the contents of an NVDIMM) as well as media errors.
> +
> +NOVA protects all of its metadata data structures with a combination of
> +replication and checksums.  It protects file data using RAID-5 style parity.

Above here it says RAID-4-style parity...???

> +
> +NOVA can detects data corruption by verifying checksums on each access and by

            detect

> +catching and handling machine check exceptions (MCEs) that arise when the
> +system's memory controller detects at uncorrectable media error.
> +
> +We use a fault injection tool that allows testing of these recovery mechanisms.
> +
> +To facilitate backups, NOVA can take snapshots of the current filesystem state
> +that can be mounted read-only while the current file system is mounted
> +read-write.
> +
> +The tech report list above describes the design of NOVA's data protection system in detail.
> +
> +### DAX Support
> +
> +Supporting DAX efficiently is a core feature of NOVA and one of the challenges
> +in designing NOVA is reconciling DAX support which aims to avoid file system
> +intervention when file data changes, and other features that require such
> +intervention.
> +
> +NOVA's philosophy with respect to DAX is that when a program uses DAX mmap to
> +to modify a file, the program must take full responsibility for that data and
> +NOVA must ensure that the memory will behave as expected.  At other times, the
> +file system provides protection.  This approach has several implications:
> +
> +1. Implementing `msync()` in user space works fine.
> +
> +2. While a file is mmap'd, it is not protected by NOVA's RAID-style parity
> +mechanism, because protecting it would be too expensive.  When the file is
> +unmapped and/or during file system recovery, protection is restored.
> +
> +3. The snapshot mechanism must be careful about the order in which in adds

                                                                      it

> +pages to the file's snapshot image.
> +
> +### Performance
> +
> +The research paper and technical report referenced above compare NOVA's
> +performance to other file systems.  In almost all cases, NOVA outperforms other
> +DAX-enabled file systems.  A notable exception is sub-page updates which incur
> +COW overheads for the entire page.
> +
> +The technical report also illustrates the trade-offs between our protection
> +mechanisms and performance.
> +
> +## Gaps, Missing Features, and Development Status
> +
> +Although NOVA is a fully-functional file system, there is still much work left
> +to be done.  In particular, (at least) the following items are currently missing:
> +
> +1.  There is no mkfs or fsk utility (`mount` takes `-o init` to create a NOVA file system)

                           fsck

> +2.  NOVA doesn't scrub data to prevent corruption from accumulating in infrequently accessed data.
> +3.  NOVA doesn't read bad block information on mount and attempt recovery of the effected data.
> +4.  NOVA only works on x86-64 kernels.
> +5.  NOVA does not currently support extended attributes or ACL.
> +6.  NOVA does not currently prevent writes to mounted snapshots.
> +7.  Using `write()` to modify pages that are mmap'd is not supported.
> +8.  NOVA deoesn't provide quota support.
> +9.  Moving NOVA file systems between machines with different numbers of CPUs does not work.
> +10. Remounting a NOVA file system with different mount options may fail.
> +
> +None of these are fundamental limitations of NOVA's design.  Additional bugs
> +and issues are here [here][https://github.com/NVSL/linux-nova/issues].
> +
> +NOVA is complete and robust enough to run a range of complex applications, but
> +it is not yet ready for production use.  Our current focus is on adding a few
> +missing features list above and finding/fixing bugs.

                    from the list above

> +
> +## Building and Using NOVA
> +
> +This repo contains a version of the Linux with NOVA included.  You should be

what repo?                      of Linux

> +able to build and install it just as you would the mainline Linux source.
> +
> +### Building NOVA
> +
> +To build NOVA, build the kernel with PMEM (`CONFIG_BLK_DEV_PMEM`), DAX (`CONFIG_FS_DAX`) and NOVA (`CONFIG_NOVA_FS`) support.  Install as usual.
> +
> +## Hacking and Contributing
> +
> +The NOVA source code is almost completely contains in the `fs/nova` directory.

                                             contained

> +The execptions are some small changes in the kernel's memory management system

       exceptions

> +to support checkpointing.
> +
> +`Documentation/filesystems/nova.txt` describes the internals of Nova in more detail.
> +
> +If you find bugs, please [report them](https://github.com/NVSL/linux-nova/issues).
> +
> +If you have other questions or suggestions you can contact the NOVA developers at [cse-nova-hackers@eng.ucsd.edu](mailto:cse-nova-hackers@eng.ucsd.edu).
> +
> +
> +[NVSL]: http://nvsl.ucsd.edu/ "http://nvsl.ucsd.edu"
> +[POSIXtest]: http://www.tuxera.com/community/posix-test-suite/ 
> +[FAST2016]: https://www.usenix.org/conference/fast16/technical-sessions
> +[CSE]: http://cs.ucsd.edu
> +[UCSD]: http://www.ucsd.edu
> \ No newline at end of file
> 


-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
