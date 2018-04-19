Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22c.google.com (mail-oi0-x22c.google.com
 [IPv6:2607:f8b0:4003:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1ADA21EBD1A3
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 13:32:07 -0700 (PDT)
Received: by mail-oi0-x22c.google.com with SMTP id t27-v6so6065796oij.9
 for <linux-nvdimm@lists.01.org>; Thu, 19 Apr 2018 13:32:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152416215323.6262.188669847137941145.stgit@djiang5-desk3.ch.intel.com>
References: <152416215323.6262.188669847137941145.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Apr 2018 13:32:05 -0700
Message-ID: <CAPcyv4it2PAnTRHW=4KNOZ-bSFXJEmMFV+D1NTJF4CTcp6G4Ow@mail.gmail.com>
Subject: Re: [PATCH] dax: allowing MAP_SYNC for device-dax mmap() to succeed
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

I'll change the "allowing" to "allow" in the subject so we don't have
a gerund phrase.

On Thu, Apr 19, 2018 at 11:22 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> MAP_SYNC is basically a nop for device-dax. However allowing the MAP_SYNC

Not "bascially", it *is* a nop for device-dax. I'll change this second
sentence to start "Allow MAP_SYNC to succeed on device-dax to
eliminate special casing between device-dax and fs-dax as to when the
flag can be specified."

> flag to succeed on device-dax would make it consistent with fs-dax and
> reduces confusion for the application writer. This allows the application to
> assume that it does not need to call fsync() after writes to device-dax
> mappings.

I'll change this last sentence to say "Device-dax users already
implicitly assume that they do not need to call fsync(), enable them
to explicitly check for this capability".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
