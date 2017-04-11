Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 275BC21939224
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 09:25:20 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id f22so2751223oib.2
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 09:25:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170411155936.11251-1-oohall@gmail.com>
References: <20170411155936.11251-1-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Apr 2017 09:25:18 -0700
Message-ID: <CAPcyv4jtucRXGCsArae58RRKwz+DQt4YrKPLQf3A=KyG8aB0RQ@mail.gmail.com>
Subject: Re: [PATCH] device-dax: Improve fault handler debug output
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 11, 2017 at 8:59 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> A couple of minor improvements to the debug output in the fault handlers:
>
> a) Print the region alignment and fault size when we sent a SIGBUS
>    because the region alignment is greater than the fault size.
> b) Fix the message in the PFN_{DEV|MAP} check.
> c) Additionally print the fault size enum value in the huge fault handler.
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>

Thanks Oliver, looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
