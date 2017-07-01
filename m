Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x229.google.com (mail-yw0-x229.google.com
 [IPv6:2607:f8b0:4002:c05::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BC7721BADAAE
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 19:19:04 -0700 (PDT)
Received: by mail-yw0-x229.google.com with SMTP id a12so7298619ywh.3
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 19:20:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170701003252.13171-1-vishal.l.verma@intel.com>
References: <20170701003252.13171-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Jun 2017 19:20:37 -0700
Message-ID: <CAPcyv4iQoRRt6_gayGOAnr41sq8CckL-wnmtiT71QAYSdbfAWQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, btt: convert some info messages to warn/err
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

On Fri, Jun 30, 2017 at 5:32 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Some critical messages such as IO errors, metadata failures were printed
> with dev_info. Make them louder by upgrading them to dev_warn or
> dev_error.
>

Ok, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
