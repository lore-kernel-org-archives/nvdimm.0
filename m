Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 069EB21A0BA9B
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 12:57:23 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id w10so43362086oif.0
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 12:57:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <13ac1fdb-6ade-b1f5-9d55-83dac5805e92@intel.com>
References: <149452561607.28242.9327540807726189144.stgit@djiang5-desk3.ch.intel.com>
 <1494527106.30303.94.camel@hpe.com>
 <13ac1fdb-6ade-b1f5-9d55-83dac5805e92@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 May 2017 12:57:21 -0700
Message-ID: <CAPcyv4jE70GBXx41YH9jbTAA+C_y873Co5Xr3DBScuFE3yqx_Q@mail.gmail.com>
Subject: Re: [PATCH v6] ndctl: add list --media-errors support
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 11, 2017 at 12:15 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 05/11/2017 11:25 AM, Kani, Toshimitsu wrote:
>> On Thu, 2017-05-11 at 11:01 -0700, Dave Jiang wrote:
>>> ACPI NFIT enabled platforms provide media errors as absolute phyiscal
>>> address offsets. Add an option to ndctl to display those media errors
>>> tranlsated to region and namespace device level offsets in an "ndctl
>>> list" listing. BTT badblocks show is not supported in this iteration
>>> and will come later.
>>>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
>>> ---
>>>
>>> v2: added fix to badblocks display from Toshi's testing result.
>>> v3: fixed naming issues from Dan's comments.
>>>     fixed badblocks boundary offset calculations from Toshi's
>>> testing.
>>> v4: Add indicator to show badblocks exist or not, per Toshi's
>>> comments.
>>> v5: Add BTT badblock_count from Toshi and Dan's comments.
>>> v6: Fix badblock_count to total number of bbs and not range per
>>> Toshi.
>>
>> Close, but there is a corner case issue.  The 1st badblocks entry
>> listed below has "528376 33" in the region, which spans both metadata
>> and data areas -- 8 sectors in the metadata and remaining 25 sectors in
>> the data.  The total number of sectors listed are 60, while
>> "badblock_count" shows 68.
>
> Actually, you pointed to a bigger problem in my code. I didn't adjust
> the badblock length when calculating the offsets. That's probably what
> causes the issue.

There's more than that. The mechanism to generically count the
badblocks in the btt case may over count in the case of 'dax', and
'memory' mode where you know which badblocks are metadata blocks vs
data blocks. I think we can fix this with documentation that states
that badblock_count may count blocks that are not in the data space of
the namespace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
