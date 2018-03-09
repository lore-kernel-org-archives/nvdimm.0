Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4200220C2A7A
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 11:52:20 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl PATCH] ndctl, list: fix sector_size listing
References: <152062242529.34816.8248756922497912006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49y3j1ujh6.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gUHmfOgfstm3qaJqO7Mx38hba_T__y_4xrAcmbn_Lg1g@mail.gmail.com>
Date: Fri, 09 Mar 2018 14:58:36 -0500
In-Reply-To: <CAPcyv4gUHmfOgfstm3qaJqO7Mx38hba_T__y_4xrAcmbn_Lg1g@mail.gmail.com>
 (Dan Williams's message of "Fri, 9 Mar 2018 11:44:07 -0800")
Message-ID: <x49tvtpuikz.fsf@segfault.boston.devel.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, Mar 9, 2018 at 11:39 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>>> Commit a7320456f1bc "ndctl: add sector_size to 'ndctl list' output"
>>> mishandles the case where a namespace does not specify a sector_size,
>>> but otherwise supports a sector_size selection:
>>>
>>>     # ndctl list --namespace=namespace1.0
>>>     {
>>>       "dev":"namespace1.0",
>>>       "mode":"memory",
>>>       "size":32763805696,
>>>       "uuid":"7c985ba5-6d33-48bd-8fde-6c25a520abe0",
>>>       "sector_size":-1,
>>>       "blockdev":"pmem1",
>>>       "numa_node":0
>>>     }
>>>
>>> Fix this and clean up the output to only provide a sector_size in the
>>> non-default (i.e. != 512 bytes) case.
>>
>> That sounds confusing.  Why not just always print out the sector size?
>
> I'm assuming the users that will go through the hassle of specifying a
> non-default sector_size are few and far between. This helps with the
> useful information density on a single screen for humans looking at
> json output.

I think that, to the novice, seeing one namespace print out sector size
and another not do the same, that would be confusing.  Also, you'd have
to know what the default is.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
