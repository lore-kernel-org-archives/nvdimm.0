Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F1FB223FCF31
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 13:52:05 -0700 (PDT)
Received: by mail-oi0-x22a.google.com with SMTP id c18so6898326oiy.9
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 13:58:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180315200151.27568-1-vishal.l.verma@intel.com>
References: <20180315200151.27568-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Mar 2018 13:58:27 -0700
Message-ID: <CAPcyv4g5YD2T8S=B_3GffpAF8TCD9wrtUePAu04zKbsL=Uc4eQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl,
 documentation: remove '...' from label-options.txt
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 15, 2018 at 1:01 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The '...' in label-options.txt ended up getting rendered as an ellipsis
> character in the online man pages, and made filtering for certain things
> a little harder. Remove it since the plural already indicates multiple
> devices can be passed.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Fine by me:

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
