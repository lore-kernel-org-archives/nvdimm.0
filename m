Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E38E2253FB58
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 11:37:51 -0800 (PST)
Received: by mail-ot0-x22c.google.com with SMTP id w38so9711920ota.8
 for <linux-nvdimm@lists.01.org>; Fri, 09 Mar 2018 11:44:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <x49y3j1ujh6.fsf@segfault.boston.devel.redhat.com>
References: <152062242529.34816.8248756922497912006.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49y3j1ujh6.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Mar 2018 11:44:07 -0800
Message-ID: <CAPcyv4gUHmfOgfstm3qaJqO7Mx38hba_T__y_4xrAcmbn_Lg1g@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, list: fix sector_size listing
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 9, 2018 at 11:39 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> Commit a7320456f1bc "ndctl: add sector_size to 'ndctl list' output"
>> mishandles the case where a namespace does not specify a sector_size,
>> but otherwise supports a sector_size selection:
>>
>>     # ndctl list --namespace=namespace1.0
>>     {
>>       "dev":"namespace1.0",
>>       "mode":"memory",
>>       "size":32763805696,
>>       "uuid":"7c985ba5-6d33-48bd-8fde-6c25a520abe0",
>>       "sector_size":-1,
>>       "blockdev":"pmem1",
>>       "numa_node":0
>>     }
>>
>> Fix this and clean up the output to only provide a sector_size in the
>> non-default (i.e. != 512 bytes) case.
>
> That sounds confusing.  Why not just always print out the sector size?

I'm assuming the users that will go through the hassle of specifying a
non-default sector_size are few and far between. This helps with the
useful information density on a single screen for humans looking at
json output.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
