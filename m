Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67F4421A16E5F
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 09:12:32 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id l18so36032725oig.2
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 09:12:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c6378b13-b919-598f-eeb6-cf383f739548@intel.com>
References: <149446050265.19998.6594654322891878230.stgit@djiang5-desk3.ch.intel.com>
 <149446059426.19998.8536490603388756669.stgit@djiang5-desk3.ch.intel.com>
 <1494516683.30303.88.camel@hpe.com>
 <c6378b13-b919-598f-eeb6-cf383f739548@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 May 2017 09:12:28 -0700
Message-ID: <CAPcyv4jY+=9trcDc2xbe+b8ywdv1KtoheeV679DUpZ8FJBcQNg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ndctl: add list --media-errors support
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

On Thu, May 11, 2017 at 9:09 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 05/11/2017 08:31 AM, Kani, Toshimitsu wrote:
>> On Wed, 2017-05-10 at 16:57 -0700, Dave Jiang wrote:
>>> ACPI NFIT enabled platforms provide media errors as absolute phyiscal
>>> address offsets. Add an option to ndctl to display those media errors
>>> tranlsated to region and namespace device level offsets in an "ndctl
>>> list" listing. BTT badblocks show is not supported in this iteration
>>> and will come later.
>>>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> ---
>>>
>>> v2: added fix to badblocks display from Toshi's testing result.
>>> v3: fixed naming issues from Dan's comments.
>>>     fixed badblocks boundary offset calculations from Toshi's
>>> testing.
>>> v4: Add indicator to show badblocks exist or not, per Toshi's
>>> comments.
>>
>> This version works pretty good, except that it does not show
>> "has_badblocks" for sector mode.
>
> Yes I intentionally left it out. I was going to add sector mode support
> as follow on after Dan accepts these patches as it required additional
> support code to read the btt badblocks file etc. If you'd rather
> everything in right now I can try to get sector mode support in now.

Sorry, crossed wires. You don't need the btt badblocks file, just
count the badblocks from the region that also fall in the namespace
range.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
