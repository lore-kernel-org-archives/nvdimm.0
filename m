Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B292210ED0FD
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 22:38:27 -0700 (PDT)
Subject: Re: [Qemu-devel] [qemu PATCH 4/5] machine: fix some misspelled words
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-4-ross.zwisler@linux.intel.com>
From: Thomas Huth <thuth@redhat.com>
Message-ID: <17f8856c-48d9-d112-cd7f-e1b3679d2f43@redhat.com>
Date: Fri, 8 Jun 2018 07:38:17 +0200
MIME-Version: 1.0
In-Reply-To: <20180607223111.27792-4-ross.zwisler@linux.intel.com>
Content-Language: en-US
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 08.06.2018 00:31, Ross Zwisler wrote:
> Normally this might not be worth fixing, but several of these are strings
> which are displayed to users.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  hw/core/machine.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index 617e5f8d75..a21269fa39 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -609,7 +609,7 @@ static void machine_class_init(ObjectClass *oc, void *data)
>          machine_get_igd_gfx_passthru, machine_set_igd_gfx_passthru,
>          &error_abort);
>      object_class_property_set_description(oc, "igd-passthru",
> -        "Set on/off to enable/disable igd passthrou", &error_abort);
> +        "Set on/off to enable/disable igd passthru", &error_abort);

Shouldn't that rather be "passthrough" instead?

 Thomas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
