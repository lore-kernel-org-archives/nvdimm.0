Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 856BA21A134AC
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 10:27:56 -0700 (PDT)
Date: Wed, 10 May 2017 11:27:55 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/4 v4] mm,dax: Fix data corruption due to mmap
 inconsistency
Message-ID: <20170510172755.GA18283@linux.intel.com>
References: <20170510085419.27601-1-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170510085419.27601-1-jack@suse.cz>
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
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 10, 2017 at 10:54:15AM +0200, Jan Kara wrote:
> Hello,
> 
> this series fixes data corruption that can happen for DAX mounts when
> page faults race with write(2) and as a result page tables get out of sync
> with block mappings in the filesystem and thus data seen through mmap is
> different from data seen through read(2).
> 
> The series passes testing with t_mmap_stale test program from Ross and also
> other mmap related tests on DAX filesystem.
> 
> Andrew, can you please merge these patches? Thanks!
> 
> Changes since v3:
> * Rebased on top of current Linus' tree due to non-trivial conflicts with
>   added tracepoint

Cool, the merge update looks correct to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
