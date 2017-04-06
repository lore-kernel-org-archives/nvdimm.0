Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 733DF20945025
 for <linux-nvdimm@lists.01.org>; Wed,  5 Apr 2017 17:20:10 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id b187so34768933oif.0
 for <linux-nvdimm@lists.01.org>; Wed, 05 Apr 2017 17:20:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149143249281.26583.1760450815293833834.stgit@djiang5-desk3.ch.intel.com>
References: <149143249281.26583.1760450815293833834.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 5 Apr 2017 17:20:09 -0700
Message-ID: <CAPcyv4iKCv8ASYUXGffnkLtP9oMp9BwQE4Vd-mGECabpj8=6aQ@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl: have daxdev-errors discover the ndbus
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

On Wed, Apr 5, 2017 at 3:48 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Implementation had static config and made assumption that the bus and region
> in nfit_test will be static. Adding code to discover the proper bus, region,
> and also pass onto daxdev-errors.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

Looks good to me. Since I haven't pushed the latest pending branch
I'll go ahead and fold / rebase this in to the original patch series.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
