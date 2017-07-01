Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22f.google.com (mail-yb0-x22f.google.com
 [IPv6:2607:f8b0:4002:c09::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4333D21B02B93
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 18:57:33 -0700 (PDT)
Received: by mail-yb0-x22f.google.com with SMTP id e201so43028460ybb.1
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 18:59:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170630200029.11797-1-vishal.l.verma@intel.com>
References: <20170630200029.11797-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Jun 2017 18:59:06 -0700
Message-ID: <CAPcyv4h2NRYb1m=Rc+diVrue-aomP1oLqO-GHwfPXjuXCz9BMg@mail.gmail.com>
Subject: Re: [ndctl PATCH v2] ndctl,
 test: unit test updates for the BTT 2.0 format
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 30, 2017 at 1:00 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> With the BTT 2.0 update, a couple of minor updates to the unit tests are
> needed:
> test/libndctl: Update expected BTT sizes
> test/libndctl: in btt_autodetect, when wiping an old BTT, wipe the first
> two 4K pages instead of one.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>
> v2:
>  - Move the new BTT size check under a 4.13.0 attempt (Dan)

Fair enough, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
