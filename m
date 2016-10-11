Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from prv-mh.provo.novell.com (prv-mh.provo.novell.com
 [137.65.248.74])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE95D1A1E8C
 for <linux-nvdimm@lists.01.org>; Tue, 11 Oct 2016 06:08:44 -0700 (PDT)
Message-Id: <57FCF26A02000078000F15E0@prv-mh.provo.novell.com>
Date: Tue, 11 Oct 2016 07:08:42 -0600
From: "Jan Beulich" <jbeulich@suse.com>
Subject: Re: [Xen-devel] [RFC KERNEL PATCH 0/2] Add Dom0 NVDIMM support for Xen
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
 <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
In-Reply-To: <dde78bbd-4739-98a1-4b69-2c2dff0a9d71@citrix.com>
Mime-Version: 1.0
Content-Disposition: inline
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
To: andrew.cooper3@citrix.com
Cc: Juergen Gross <JGross@suse.com>, guangrong.xiao@linux.intel.com, arnd@arndb.de, linux-nvdimm@lists.01.org, boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org, stefano@aporeto.com, david.vrabel@citrix.com, xen-devel@lists.xenproject.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

>>> Andrew Cooper <andrew.cooper3@citrix.com> 10/10/16 6:44 PM >>>
>On 10/10/16 01:35, Haozhong Zhang wrote:
>> Xen hypervisor needs assistance from Dom0 Linux kernel for following tasks:
>> 1) Reserve an area on NVDIMM devices for Xen hypervisor to place
>>    memory management data structures, i.e. frame table and M2P table.
>> 2) Report SPA ranges of NVDIMM devices and the reserved area to Xen
>>    hypervisor.
>
>However, I can't see any justification for 1).  Dom0 should not be
>involved in Xen's management of its own frame table and m2p.  The mfns
>making up the pmem/pblk regions should be treated just like any other
>MMIO regions, and be handed wholesale to dom0 by default.

That precludes the use as RAM extension, and I thought earlier rounds of
discussion had got everyone in agreement that at least for the pmem case
we will need some control data in Xen.

Jan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
