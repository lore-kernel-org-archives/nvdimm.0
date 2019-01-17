Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6EA9F211B85C6
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 13:57:21 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/4] Allow persistent memory to be used like normal RAM
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <x49sgxr9rjd.fsf@segfault.boston.devel.redhat.com>
 <20190117164736.GC31543@localhost.localdomain>
 <x49pnsv8am1.fsf@segfault.boston.devel.redhat.com>
 <20190117193403.GD31543@localhost.localdomain>
Date: Thu, 17 Jan 2019 16:57:17 -0500
In-Reply-To: <20190117193403.GD31543@localhost.localdomain> (Keith Busch's
 message of "Thu, 17 Jan 2019 12:34:03 -0700")
Message-ID: <x49ef9b6j7m.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Keith Busch <keith.busch@intel.com>
Cc: thomas.lendacky@amd.com, dave@sr71.net, linux-nvdimm@lists.01.org, tiwai@suse.de, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, akpm@linux-foundation.org, fengguang.wu@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Keith Busch <keith.busch@intel.com> writes:

>> Keith, you seem to be implying that there are platforms that won't
>> support memory mode.  Do you also have some insight into how customers
>> want to use this, beyond my speculation?  It's really frustrating to see
>> patch sets like this go by without any real use cases provided.
>
> Right, most NFIT reporting platforms today don't have memory mode, and
> the kernel currently only supports the persistent DAX mode with these.
> This series adds another option for those platforms.

All NFIT reporting platforms today are shipping NVDIMM-Ns, where it
makes absolutely no sense to use them as regular DRAM.  I don't think
that's a good argument to make.

> I think numactl as you mentioned is the first consideration for how
> customers may make use. Dave or Dan might have other use cases in mind.

Well, it sure looks like this took a lot of work, so I thought there
were known use cases or users asking for this functionality.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
