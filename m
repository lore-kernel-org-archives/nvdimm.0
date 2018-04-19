Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECF4421EBD1C4
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 14:08:14 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id x9-v6so6166444oig.7
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 14:08:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152417033504.18702.8933921557309052260.stgit@djiang5-desk3.ch.intel.com>
References: <152417033504.18702.8933921557309052260.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Apr 2018 14:08:13 -0700
Message-ID: <CAPcyv4gNjvn5=f5K8oRG7dgh_O0Hu5_bjJ+X95yrYHR42p2x8w@mail.gmail.com>
Subject: Re: [PATCH v2] dax: allow MAP_SYNC for device-dax mmap() to succeed
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 19, 2018 at 1:39 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> MAP_SYNC is a nop for device-dax. Allow MAP_SYNC to succeed on device-dax
> to eliminate special casing between device-dax and fs-dax as to when the
> flag can be specified. Device-dax users already implicitly assume that they do
> not need to call fsync(), and this enables them to explicitly check for this
> capability.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>
> v2: update commit message with suggestion from Dan.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
