Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64E76211B6C23
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 15:06:44 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id k98so14608749otk.3
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 15:06:44 -0800 (PST)
MIME-Version: 1.0
References: <47b0eaaa-ad49-5062-5f1f-fb6f79b2448d@oracle.com>
 <3908561D78D1C84285E8C5FCA982C28F7D4C4F61@ORSMSX110.amr.corp.intel.com>
 <ca4e6f85-9bf1-9421-5207-ac855882c245@oracle.com>
 <CAPcyv4jo8-Mgoa0=2bD9uTUy17VJGVZvj-Pf_RszPmv=Q_GQpQ@mail.gmail.com>
 <20190111221245.GA6231@agluck-desk>
 <CAPcyv4iv5GdmdoCmz4QNz9r6e-GxOPBK-tekJkio_AzhoFKErQ@mail.gmail.com>
 <20190111224637.GA7300@agluck-desk>
In-Reply-To: <20190111224637.GA7300@agluck-desk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jan 2019 15:06:33 -0800
Message-ID: <CAPcyv4ieiCN+TN44HA0G-PSELNTJPctSgrULhdVJGO_hcmu2rQ@mail.gmail.com>
Subject: Re: [PATCH] acpi/nfit: Fix race accessing memdev in
 nfit_get_smbios_id()
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 11, 2019 at 2:46 PM Luck, Tony <tony.luck@intel.com> wrote:
>
>
> Possible race accessing memdev structures after dropping the
> mutex. Dan Williams says this could race against another thread
> that is doing:
>
>  # echo "ACPI0012:00" > /sys/bus/acpi/drivers/nfit/unbind
>
> Reported-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>
> This time with a commit message and credit to Jane for finding it.

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
