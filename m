Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BE51F21CEB153
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 14:06:24 -0700 (PDT)
Date: Tue, 24 Oct 2017 15:10:07 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Message-ID: <20171024211007.GA1611@linux.intel.com>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-19-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171024152415.22864-19-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 24, 2017 at 05:24:15PM +0200, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>

This looks unchanged since the previous version?

> ---
>  man2/mmap.2 | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/man2/mmap.2 b/man2/mmap.2
> index 47c3148653be..598ff0c64f7f 100644
> --- a/man2/mmap.2
> +++ b/man2/mmap.2
> @@ -125,6 +125,21 @@ are carried through to the underlying file.
>  to the underlying file requires the use of
>  .BR msync (2).)
>  .TP
> +.B MAP_SHARED_VALIDATE
> +The same as
> +.B MAP_SHARED
> +except that
> +.B MAP_SHARED
> +mappings ignore unknown flags in
> +.IR flags .
> +In contrast when creating mapping of
> +.B MAP_SHARED_VALIDATE
> +mapping type, the kernel verifies all passed flags are known and fails the
> +mapping with
> +.BR EOPNOTSUPP
> +otherwise. This mapping type is also required to be able to use some mapping
> +flags.
> +.TP
>  .B MAP_PRIVATE
>  Create a private copy-on-write mapping.
>  Updates to the mapping are not visible to other processes
> @@ -352,6 +367,21 @@ option.
>  Because of the security implications,
>  that option is normally enabled only on embedded devices
>  (i.e., devices where one has complete control of the contents of user memory).
> +.TP
> +.BR MAP_SYNC " (since Linux 4.15)"
> +This flags is available only with
> +.B MAP_SHARED_VALIDATE
> +mapping type. Mappings of
> +.B MAP_SHARED
> +type will silently ignore this flag.
> +This flag is supported only for files supporting DAX (direct mapping of persistent
> +memory). For other files, creating mapping with this flag results in
> +.B EOPNOTSUPP
> +error. Shared file mappings with this flag provide the guarantee that while
> +some memory is writeably mapped in the address space of the process, it will
> +be visible in the same file at the same offset even after the system crashes or
> +is rebooted. This allows users of such mappings to make data modifications
> +persistent in a more efficient way using appropriate CPU instructions.
>  .PP
>  Of the above flags, only
>  .B MAP_FIXED
> -- 
> 2.12.3
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
