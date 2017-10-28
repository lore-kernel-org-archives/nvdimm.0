Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 47F4621F3B3F4
 for <linux-nvdimm@lists.01.org>; Sat, 28 Oct 2017 16:16:47 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id g125so16062277oib.12
 for <linux-nvdimm@lists.01.org>; Sat, 28 Oct 2017 16:20:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150774466038.55191.18214496952092405741.stgit@djiang5-desk3.ch.intel.com>
References: <150774466038.55191.18214496952092405741.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 28 Oct 2017 16:20:35 -0700
Message-ID: <CAPcyv4je-OTk9e3ay4SV2hEkUEkT_XFtFBnyu+f1pD39FQzwNg@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: add smart payload fields added in DSM 1.6
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
Cc: "Balcer, Piotr" <piotr.balcer@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 10:57 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> NVDIMM DSM interface v1.6 added additional smart health fields. Updating the
> smart payload data structure accordingly.

I've thought about this a bit more and given the fact that this is out
of date and the SMART threshold payload has changed in an incompatible
manner in the latest spec, I'm going to deprecate these payloads. The
threshold breakage is unfortunate but given the thresholds can not be
set until support for the new 'set threshold' dsm the impact is
limited. We'll leave these payloads in the kernel until there are no
versions of ndctl shipping in distributions that depend on them.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
