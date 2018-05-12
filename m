Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F040D210E0FB6
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 18:43:27 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id h8-v6so8290002otb.2
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 18:43:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180512013450.GA4189@linux.intel.com>
References: <152607009656.4523.5355287262776399070.stgit@djiang5-desk3.ch.intel.com>
 <20180512013450.GA4189@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 May 2018 18:43:25 -0700
Message-ID: <CAPcyv4inRfrVN8nAOUAToPUBwJZopfn9a2m-L-EBajvbuq6CPQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] ndctl: convert actions to use util_filter_walk
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 11, 2018 at 6:34 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, May 11, 2018 at 01:24:36PM -0700, Dave Jiang wrote:
>> util_filter_walk() does the looping through bus/dimm/region/namespace
>> that a lot of the operations in ndctl uses. Converting them to common
>> code and reduce maintenance on individual versions of the same code.
>> In this series we are convering namespace, region, and dimm actions.
>
> <>
>
>>  ndctl/dimm.c      |   78 +++++++++++++---------
>>  ndctl/namespace.c |  189 +++++++++++++++++++++++++++++------------------------
>>  ndctl/region.c    |   54 +++++++++------
>>  util/filter.c     |   11 +++
>>  util/filter.h     |   25 +++++++
>>  5 files changed, 212 insertions(+), 145 deletions(-)
>
> Just from the cover letter I'm sort of confused - the paragraph above says we
> are converging on common code and removing individual versions of the same
> code...but the patch series grows this code by 70 lines?  I would have
> expected this to be a net code reduction?

It's a fair point about the changelog relative to the diffstat. I
assume we are also adding the common object looping pattern as part of
this conversion, so we're gaining functionality?

I.e. does:

    ndctl disable-region region0 region1

...work now? Previously it was only a singleton. I thought that was
the motivation?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
