Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29D46211B5075
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 22:23:15 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id a77so5414892oii.5
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 22:23:15 -0800 (PST)
MIME-Version: 1.0
References: <1546828416-3040-1-git-send-email-lixiaochun.2888@163.com>
 <1546828416-3040-2-git-send-email-lixiaochun.2888@163.com>
In-Reply-To: <1546828416-3040-2-git-send-email-lixiaochun.2888@163.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Jan 2019 22:23:03 -0800
Message-ID: <CAPcyv4gO-N8vJgZjKR3rMLivqOAxHAjCT-KoLEE4U6w3sk==-Q@mail.gmail.com>
Subject: Re: [PATCH] ACPI/nfit: delete the redundant header file
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
To: Xiaochun Lee <lixiaochun.2888@163.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Xiaochun Lee <lixc17@lenovo.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 6, 2019 at 6:33 PM Xiaochun Lee <lixiaochun.2888@163.com> wrote:
>
> From: Xiaochun Lee <lixc17@lenovo.com>
>
> The header file "intel.h" is repeated here, So delete one.
>
> Signed-off-by: Xiaochun Lee <lixc17@lenovo.com>

Thanks, applied.

By the way, no need for a cover letter if it's only one patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
