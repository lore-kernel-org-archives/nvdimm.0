Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from merlin.infradead.org (merlin.infradead.org
 [IPv6:2001:8b0:10b:1231::1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8B43A2202E488
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 17:27:46 -0700 (PDT)
Subject: Re: [RFC v2 83/83] Sysfs support.
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-84-git-send-email-jix024@eng.ucsd.edu>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d5d16cfa-dbd2-b874-38e4-cbb9d7d783ff@infradead.org>
Date: Wed, 14 Mar 2018 17:33:43 -0700
MIME-Version: 1.0
In-Reply-To: <1520705944-6723-84-git-send-email-jix024@eng.ucsd.edu>
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
To: Andiry Xu <jix024@eng.ucsd.edu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

On 03/10/2018 10:19 AM, Andiry Xu wrote:
> Sysfs support allows user to get/post information of running NOVA instance.
> After mount, NOVA creates four entries under proc directory
> /proc/fs/nova/pmem#/:
> 
> timing_stats	IO_stats	allocator	gc

Hi,

This is all procfs, not sysfs, so the name is (or can be) confusing.

Please change it.

-- 
~Randy
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
