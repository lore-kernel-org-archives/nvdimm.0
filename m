Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x232.google.com (mail-ot0-x232.google.com
 [IPv6:2607:f8b0:4003:c0f::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 77440202E5EFE
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 19:32:53 -0700 (PDT)
Received: by mail-ot0-x232.google.com with SMTP id y10-v6so14703651otg.10
 for <linux-nvdimm@lists.01.org>; Wed, 25 Apr 2018 19:32:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180426005648.13028-1-qi.fuli@jp.fujitsu.com>
References: <20180426005648.13028-1-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 Apr 2018 19:32:51 -0700
Message-ID: <CAPcyv4hVPC1s3gT6+nSke1HOv-WbQ_OLiySdxhyowFWWT5JDRw@mail.gmail.com>
Subject: Re: [PATCH v2] ndctl,
 filter: fix "keyword 'all' is ignored" in util_<obj>_filter()
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 25, 2018 at 5:56 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This is a follow up patch for commit c70adc3cf6bf ("ndctl, filter: refactor
> util_<obj>_filter() to support multiple space-seperated arguments")
> refactored util_<obj>_filter() to support multiple space-seperated arguments.
> But, when the keyword "all" is included in space-seperated arguments,
> it will be treaded as <object>'s name. This patch fixes it.
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
