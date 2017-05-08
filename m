Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 226FD21A0BAA1
 for <linux-nvdimm@lists.01.org>; Mon,  8 May 2017 10:27:09 -0700 (PDT)
Date: Mon, 8 May 2017 11:27:07 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/4 v2] mm,dax: Fix data corruption due to mmap
 inconsistency
Message-ID: <20170508172707.GB18408@linux.intel.com>
References: <20170505072500.25692-1-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170505072500.25692-1-jack@suse.cz>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 05, 2017 at 09:24:56AM +0200, Jan Kara wrote:
> Hello,
> 
> this series fixes data corruption that can happen for DAX mounts when
> page faults race with write(2) and as a result page tables get out of sync
> with block mappings in the filesystem and thus data seen through mmap is
> different from data seen through read(2).
> 
> The series passes testing with t_mmap_stale test program from Ross and also
> other mmap related tests on DAX filesystem. Ross, what you think?

I don't know if I have enough ext4-fu to properly review patch 3, but the rest
looks great (and that patch looks good to me as well, FWIW).  Thanks for
fixing this!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
