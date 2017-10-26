Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FF1D203525FD
 for <linux-nvdimm@lists.01.org>; Thu, 26 Oct 2017 06:20:18 -0700 (PDT)
Date: Thu, 26 Oct 2017 15:24:02 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Message-ID: <20171026132402.GB31161@quack2.suse.cz>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-19-jack@suse.cz>
 <20171024211007.GA1611@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20171024211007.GA1611@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 24-10-17 15:10:07, Ross Zwisler wrote:
> On Tue, Oct 24, 2017 at 05:24:15PM +0200, Jan Kara wrote:
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> This looks unchanged since the previous version?

Ah, thanks for checking. I forgot to commit modifications. Attached is
really updated patch.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--GvXjxJ+pjyke8COw
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-mmap.2-Add-description-of-MAP_SHARED_VALIDATE-and-MA.patch"

>From 59eeec2998ed9b3840aab951f213148cb1d053a5 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 19 Oct 2017 14:44:55 +0200
Subject: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and MAP_SYNC

Signed-off-by: Jan Kara <jack@suse.cz>
---
 man2/mmap.2 | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/man2/mmap.2 b/man2/mmap.2
index 47c3148653be..b38ee6809327 100644
--- a/man2/mmap.2
+++ b/man2/mmap.2
@@ -125,6 +125,21 @@ are carried through to the underlying file.
 to the underlying file requires the use of
 .BR msync (2).)
 .TP
+.BR MAP_SHARED_VALIDATE " (since Linux 4.15)"
+The same as
+.B MAP_SHARED
+except that
+.B MAP_SHARED
+mappings ignore unknown flags in
+.IR flags .
+In contrast when creating mapping of
+.B MAP_SHARED_VALIDATE
+mapping type, the kernel verifies all passed flags are known and fails the
+mapping with
+.BR EOPNOTSUPP
+otherwise. This mapping type is also required to be able to use some mapping
+flags.
+.TP
 .B MAP_PRIVATE
 Create a private copy-on-write mapping.
 Updates to the mapping are not visible to other processes
@@ -134,7 +149,10 @@ It is unspecified whether changes made to the file after the
 .BR mmap ()
 call are visible in the mapped region.
 .PP
-Both of these flags are described in POSIX.1-2001 and POSIX.1-2008.
+.B MAP_SHARED
+and
+.B MAP_PRIVATE
+are described in POSIX.1-2001 and POSIX.1-2008.
 .PP
 In addition, zero or more of the following values can be ORed in
 .IR flags :
@@ -352,6 +370,21 @@ option.
 Because of the security implications,
 that option is normally enabled only on embedded devices
 (i.e., devices where one has complete control of the contents of user memory).
+.TP
+.BR MAP_SYNC " (since Linux 4.15)"
+This flags is available only with
+.B MAP_SHARED_VALIDATE
+mapping type. Mappings of
+.B MAP_SHARED
+type will silently ignore this flag.
+This flag is supported only for files supporting DAX (direct mapping of persistent
+memory). For other files, creating mapping with this flag results in
+.B EOPNOTSUPP
+error. Shared file mappings with this flag provide the guarantee that while
+some memory is writeably mapped in the address space of the process, it will
+be visible in the same file at the same offset even after the system crashes or
+is rebooted. This allows users of such mappings to make data modifications
+persistent in a more efficient way using appropriate CPU instructions.
 .PP
 Of the above flags, only
 .B MAP_FIXED
-- 
2.12.3


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

--GvXjxJ+pjyke8COw--
