Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x241.google.com (mail-qk0-x241.google.com
 [IPv6:2607:f8b0:400d:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63CB22256861D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 13:38:06 -0800 (PST)
Received: by mail-qk0-x241.google.com with SMTP id b130so5196262qkg.9
 for <linux-nvdimm@lists.01.org>; Fri, 09 Mar 2018 13:44:24 -0800 (PST)
Subject: Re: [ndctl PATCH] ndctl, list: fix sector_size listing
References: <152062242529.34816.8248756922497912006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49y3j1ujh6.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gUHmfOgfstm3qaJqO7Mx38hba_T__y_4xrAcmbn_Lg1g@mail.gmail.com>
 <x49tvtpuikz.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4iwbfobo4Dmq3nFvtcpiVVTdHEq=Nqf6asEft-QbuMemw@mail.gmail.com>
From: Linda Knippers <ljklists@gmail.com>
Message-ID: <d39d066f-4b12-8a90-08f6-6fd7737f74ba@gmail.com>
Date: Fri, 9 Mar 2018 16:44:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iwbfobo4Dmq3nFvtcpiVVTdHEq=Nqf6asEft-QbuMemw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 03/09/2018 04:23 PM, Dan Williams wrote:
> On Fri, Mar 9, 2018 at 11:58 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>>> On Fri, Mar 9, 2018 at 11:39 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>>> Dan Williams <dan.j.williams@intel.com> writes:
>>>>
>>>>> Commit a7320456f1bc "ndctl: add sector_size to 'ndctl list' output"
>>>>> mishandles the case where a namespace does not specify a sector_size,
>>>>> but otherwise supports a sector_size selection:
>>>>>
>>>>>     # ndctl list --namespace=namespace1.0
>>>>>     {
>>>>>       "dev":"namespace1.0",
>>>>>       "mode":"memory",
>>>>>       "size":32763805696,
>>>>>       "uuid":"7c985ba5-6d33-48bd-8fde-6c25a520abe0",
>>>>>       "sector_size":-1,
>>>>>       "blockdev":"pmem1",
>>>>>       "numa_node":0
>>>>>     }
>>>>>
>>>>> Fix this and clean up the output to only provide a sector_size in the
>>>>> non-default (i.e. != 512 bytes) case.
>>>>
>>>> That sounds confusing.  Why not just always print out the sector size?
>>>
>>> I'm assuming the users that will go through the hassle of specifying a
>>> non-default sector_size are few and far between. This helps with the
>>> useful information density on a single screen for humans looking at
>>> json output.
>>
>> I think that, to the novice, seeing one namespace print out sector size
>> and another not do the same, that would be confusing.  Also, you'd have
>> to know what the default is.

As a former ndctl user, I'm with Jeff.

> Yes, but personally I think it is only an expert that would care about
> non-512 byte sector sizes. There are no device physics or other
> benefits that require different sector sizes. The only potential
> benefit is amortizing the cost of BTT over larger sectors, but for
> Linux ext4 and xfs should be fine without a BTT. The UEFI spec
> unfortunately requires a default of 4K sector size, but that's only
> for inter-OS compatibility. I'm just finding it hard to justify
> treating sector_size as a first class attribute that the typical user
> would care about.

Since the value can be set, even to the default value, and the kernel default doesn't
match the UEFI default, it seems worth including in all cases.

-- ljk

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
