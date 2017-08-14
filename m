Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x236.google.com (mail-yw0-x236.google.com
 [IPv6:2607:f8b0:4002:c05::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 937BB21D18228
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 13:48:20 -0700 (PDT)
Received: by mail-yw0-x236.google.com with SMTP id u207so62000743ywc.3
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 13:50:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170814203422.28284-1-vishal.l.verma@intel.com>
References: <20170814203422.28284-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Aug 2017 13:50:42 -0700
Message-ID: <CAPcyv4iau_q0KzxzAm_Rgf2OnS7VKNM0qv+ZMS7TS_mbtaAanQ@mail.gmail.com>
Subject: Re: [PATCH] bash completion: updates for the improved filtering
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

On Mon, Aug 14, 2017 at 1:34 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> ndctl added improved filtering means, allowing one to filter listings
> with any combination of bus, dimm, region, or namespace. Make bash
> completion use that to only show the filtered set for any object. For
> example:
>
> $ ndctl list --region=region6 --dimm=nmem<tab>
> nmem0   nmem1

Slick! Applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
