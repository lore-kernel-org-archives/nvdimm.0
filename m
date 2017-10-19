Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9CE8C2034C0BA
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 16:56:21 -0700 (PDT)
Subject: Re: what happened to byte-addressable read()/write() to character
 device DAX?
References: <efdf3c01-b91b-4b69-33a8-90cbccfe803d@oracle.com>
 <x494lquhl3k.fsf@segfault.boston.devel.redhat.com>
 <CAA9_cmc+rM_+=tFXw1dYqyuZdiV7KstmBG6aOku+4CBmk6++iw@mail.gmail.com>
From: jane.chu@oracle.com
Message-ID: <4bdb8de6-72ab-8b21-56e9-97903875ea24@oracle.com>
Date: Thu, 19 Oct 2017 16:59:55 -0700
MIME-Version: 1.0
In-Reply-To: <CAA9_cmc+rM_+=tFXw1dYqyuZdiV7KstmBG6aOku+4CBmk6++iw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: "JANE.CHU" <jane.chu@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 10/19/2017 03:33 PM, Dan Williams wrote:

> On Thu, Oct 19, 2017 at 2:41 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> jane.chu@oracle.com writes:
>>
>>> Hi, Dan,
>>>
>>> Referring to
>>>
>>> https://patchwork.kernel.org/project/linux-nvdimm/list/?page=6
>>>
>>> [RFC,2/2] mm, fs: daxfile, an interface for byte-addressable updates
>>> to pmem
>>>
>>> I'm unable to find the patch in Linux upstream kernel, and am wondering if
>>> there has been a change of plan for providing support to byte granularity
>>> read() and write() to character device /dev/dax.
>>>
>>> I've also just started following the email threads, so I might have
>>> missed some critical discussions.  Would you mind to elaborate what's
>>> happening to the proposed feature?
>> Device dax only supports mmap for data path access.  There are no plans
>> to support read(2) or write(2).
> Yes, and the patch set referenced about was not about read(2)/write(2)
> it was about support for mmap writes without requiring them to be
> backstopped by calls to msync(). That proposal morphed into the
> MAP_SYNC and MAP_DIRECT proposals. MAP_SYNC is targeting 4.15.
> MAP_DIRECT is being reworked into an RDMA-memory-registration-specific
> interface.

Thank you both for the clarification!
Is there documents that elaborate the new resolve in detail?

-jane
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
