Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0E3B21F833A8
 for <linux-nvdimm@lists.01.org>; Sun, 11 Feb 2018 12:12:50 -0800 (PST)
Received: by mail-oi0-x22e.google.com with SMTP id c189so9695775oib.12
 for <linux-nvdimm@lists.01.org>; Sun, 11 Feb 2018 12:18:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180209080225.5137-2-qi.fuli@jp.fujitsu.com>
References: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
 <20180209080225.5137-2-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 11 Feb 2018 12:18:37 -0800
Message-ID: <CAPcyv4hfb2+2nXNpG8A7kQDWx86mGETe5J=tRQJxyHwwKNfZcA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/5] ndctl: nvdimmd: add LOG_NOTICE level to
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 9, 2018 at 12:02 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch adds LOG_NOTICE level to log_priority for the notifications
> of nvdimm dimm over threshold event. Currently, the LOG_INFO level
> is too low, and the notifications are not up to LOG_ERROR level.
>

Looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
