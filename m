Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6F8C821D492DE
 for <linux-nvdimm@lists.01.org>; Thu,  7 Sep 2017 15:22:15 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id x190so5866360oix.3
 for <linux-nvdimm@lists.01.org>; Thu, 07 Sep 2017 15:25:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170907140049.7F71.E1E9C6FF@jp.fujitsu.com>
References: <20170907140049.7F71.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 7 Sep 2017 15:25:06 -0700
Message-ID: <CAPcyv4gZdvJNrnjzMOG+=K1FLWG6gnGDrsKksHR0fYGzFtnXgg@mail.gmail.com>
Subject: Re: [ndctl PATCH v5 0/5] ndctl: show broken dimm info with translate
 SPA feature.
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 6, 2017 at 10:00 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> Hi,
>
> I wrote v5 patch set to show broken NVDIMM for ndctl list command.
> If possible, please merge it.

Ok, I merged patches 1 - 4 with some minor fixups. I moved
ndctl_bus_nfit_translate_spa() from libndctl-nfit.h into private.h
since the interface end applications should be using is the generic
ndctl_dimm_get_by_physical_address().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
