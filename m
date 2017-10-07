Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90D9621CF58A4
 for <linux-nvdimm@lists.01.org>; Sat,  7 Oct 2017 08:40:48 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id v9so21605920oif.13
 for <linux-nvdimm@lists.01.org>; Sat, 07 Oct 2017 08:44:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171006015405.29908-2-vishal.l.verma@intel.com>
References: <20171006015405.29908-1-vishal.l.verma@intel.com>
 <20171006015405.29908-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 7 Oct 2017 08:44:11 -0700
Message-ID: <CAPcyv4grhbmVjpSLe7CoVoBh2H1oe46LFCvCviLP=sUxese_Og@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/8] libndctl: fix a memory leak in add_bus
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

On Thu, Oct 5, 2017 at 6:53 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> We allocated a buffer for wait_probe_path via strdup, but failed to free
> it in the error path.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---

Applied, thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
