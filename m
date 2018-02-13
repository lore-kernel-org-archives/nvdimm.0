Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1B0321CF1CF8
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 13:21:36 -0800 (PST)
Received: by mail-ot0-x243.google.com with SMTP id s4so18572509oth.7
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 13:27:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151855080982.41933.1906244270307534998.stgit@djiang5-desk3.ch.intel.com>
References: <151855080982.41933.1906244270307534998.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Feb 2018 13:27:26 -0800
Message-ID: <CAPcyv4jf1s3urq0GH1tn8oaN1w9UhDkhmmPB09GCyWLaVDCOew@mail.gmail.com>
Subject: Re: [PATCH v3] ndctl: add option to list firmware information for a
 DIMM
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Feb 13, 2018 at 11:41 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding firmware output of firmware information when ndctl list -D -F is used.
> Components displayed are current firmware version, updated firmware version,
> and if a coldboot is required (firmware updated).
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v3:
> - Fixed issue where it skips displaying rest of the details if there's no
>   firmware details.
>
> v2:
> - Added copyright
> - Added support for human readable option (hex) for versions
> - Removed check against CMD_CALL as it's not useful
>
>  Documentation/ndctl/ndctl-list.txt |   13 +++++
>  ndctl/Makefile.am                  |    1
>  ndctl/list.c                       |   13 +++++
>  ndctl/util/json-firmware.c         |   90 ++++++++++++++++++++++++++++++++++++
>  util/json.h                        |    2 +
>  5 files changed, 119 insertions(+)
>  create mode 100644 ndctl/util/json-firmware.c
>
> diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
> index fc07a71..85b87d4 100644
> --- a/Documentation/ndctl/ndctl-list.txt
> +++ b/Documentation/ndctl/ndctl-list.txt
> @@ -110,6 +110,19 @@ include::xable-region-options.txt[]
>    }
>  }
>
> +-F::
> +--firmware::
> +       Include dimm firmware info in the listing. For example:
> +[verse]
> +{
> +  "dev":"nmem0",
> +  "firmware":{
> +      "current_version":0,
> +      "next_version":1,
> +      "coldboot_required":true
> +  }
> +}
> +
>  -X::
>  --device-dax::
>         Include device-dax ("daxregion") details when a namespace is in
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 2054c1a..e0db97b 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -13,6 +13,7 @@ ndctl_SOURCES = ndctl.c \
>                 test.c \
>                 ../util/json.c \
>                 util/json-smart.c \
> +               util/json-firmware.c \
>                 inject-error.c \
>                 update.c \
>                 inject-smart.c
> diff --git a/ndctl/list.c b/ndctl/list.c
> index 37a224a..8bb9920 100644
> --- a/ndctl/list.c
> +++ b/ndctl/list.c
> @@ -35,6 +35,7 @@ static struct {
>         bool dax;
>         bool media_errors;
>         bool human;
> +       bool firmware;
>  } list;
>
>  static unsigned long listopts_to_flags(void)
> @@ -277,6 +278,7 @@ int cmd_list(int argc, const char **argv, void *ctx)
>                                 "filter by region-type"),
>                 OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
>                 OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
> +               OPT_BOOLEAN('F', "firmware", &list.firmware, "include firmware info"),
>                 OPT_BOOLEAN('H', "health", &list.health, "include dimm health"),
>                 OPT_BOOLEAN('R', "regions", &list.regions,
>                                 "include region info"),
> @@ -420,6 +422,17 @@ int cmd_list(int argc, const char **argv, void *ctx)
>                                 }
>                         }
>
> +                       if (list.firmware) {
> +                               struct json_object *jfirmware;
> +
> +                               jfirmware = util_dimm_firmware_to_json(dimm,
> +                                               listopts_to_flags());
> +                               if (jfirmware)
> +                                       json_object_object_add(jdimm,
> +                                                       "firmware",
> +                                                       jfirmware);
> +                       }
> +
>                         /*
>                          * Without a bus we are collecting dimms anonymously
>                          * across the platform.
> diff --git a/ndctl/util/json-firmware.c b/ndctl/util/json-firmware.c
> new file mode 100644
> index 0000000..a6c33d8
> --- /dev/null
> +++ b/ndctl/util/json-firmware.c
> @@ -0,0 +1,90 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
> +#include <limits.h>
> +#include <util/json.h>
> +#include <uuid/uuid.h>
> +#include <json-c/json.h>
> +#include <ndctl/libndctl.h>
> +#include <ccan/array_size/array_size.h>
> +#include <ndctl.h>
> +
> +struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
> +               unsigned long flags)
> +{
> +       struct json_object *jfirmware = json_object_new_object();
> +       struct json_object *jobj;
> +       struct ndctl_cmd *cmd;
> +       int rc;
> +       uint64_t run, updated;
> +       bool reboot = false;
> +
> +       if (!jfirmware)
> +               return NULL;
> +
> +       cmd = ndctl_dimm_cmd_new_fw_get_info(dimm);
> +       if (!cmd)
> +               goto err;
> +
> +       rc = ndctl_cmd_submit(cmd);
> +       if (rc || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
> +               jobj = json_object_new_string("unknown");
> +               if (jobj)
> +                       json_object_object_add(jfirmware, "current_version",
> +                                       jobj);
> +               goto out;
> +       }
> +
> +       run = ndctl_cmd_fw_info_get_run_version(cmd);
> +       if (run == ULLONG_MAX) {
> +               jobj = json_object_new_string("unknown");
> +               if (jobj)
> +                       json_object_object_add(jfirmware, "current_version",
> +                                       jobj);
> +               goto out;
> +       }
> +
> +       jobj = util_json_object_hex(run, flags);
> +       if (jobj)
> +               json_object_object_add(jfirmware, "current_version", jobj);
> +
> +       updated = ndctl_cmd_fw_info_get_updated_version(cmd);
> +       if (updated == ULLONG_MAX) {
> +               jobj = json_object_new_string("unknown");
> +               if (jobj)
> +                       json_object_object_add(jfirmware, "next_version",
> +                                       jobj);
> +               goto out;
> +       }
> +
> +       if (updated == 0) {
> +               jobj = json_object_new_string("none");
> +               if (jobj)
> +                       json_object_object_add(jfirmware, "next_version",
> +                                       jobj);

I think we should emit nothing in this case. Because now the data type
of this field changes whether there is data or not. I think that will
cause problems for operations tooling that may want to ingest this
json without per-field type handling.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
