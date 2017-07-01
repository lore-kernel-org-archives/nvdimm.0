Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x230.google.com (mail-yw0-x230.google.com
 [IPv6:2607:f8b0:4002:c05::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAF9F21B02BBE
 for <linux-nvdimm@lists.01.org>; Sat,  1 Jul 2017 14:04:58 -0700 (PDT)
Received: by mail-yw0-x230.google.com with SMTP id l21so51552849ywb.1
 for <linux-nvdimm@lists.01.org>; Sat, 01 Jul 2017 14:06:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170701003321.13360-2-vishal.l.verma@intel.com>
References: <20170701003321.13360-1-vishal.l.verma@intel.com>
 <20170701003321.13360-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 1 Jul 2017 14:06:32 -0700
Message-ID: <CAPcyv4gHrW6SRycszc960vZss9t29KgswMKgpqktOy1EPDkcBg@mail.gmail.com>
Subject: Re: [PATCH] ndctl: add lbasize to read-label json output
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

On Fri, Jun 30, 2017 at 5:33 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The UEFI 2.7 spec labels add a new lbasize field to labels. Add it to
> the json output of read-labels.
>
> Reported-by: Kaushik Kanetkar <kaushik.a.kanetkar@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
