Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 83218212E13BB
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 19:53:57 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id l15so53869859otn.9
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jul 2019 19:51:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190724215741.18556-1-vishal.l.verma@intel.com>
 <20190724215741.18556-10-vishal.l.verma@intel.com>
In-Reply-To: <20190724215741.18556-10-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 25 Jul 2019 19:51:19 -0700
Message-ID: <CAPcyv4iEs533oD6X5G5-5cL2-br268FekXR8W=gTZOUbBPZBdQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v7 09/13] daxctl: add commands to online and offline
 memory
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 24, 2019 at 2:58 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add two new commands:
>
>   daxctl-online-memory
>   daxctl-offline-memory
>
> to manage the state of hot-plugged memory from the system-ram mode for
> dax devices. This provides a way for the user to online/offline the
> memory as a separate step from the reconfiguration. Without this, a user
> that reconfigures a device into the system-ram mode with the --no-online
> option, would have no way to later online the memory, and would have to
> resort to shell scripting to online them manually via sysfs.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  daxctl/builtin.h |   2 +
>  daxctl/daxctl.c  |   2 +
>  daxctl/device.c  | 131 ++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 134 insertions(+), 1 deletion(-)
>
> diff --git a/daxctl/builtin.h b/daxctl/builtin.h
> index 756ba2a..f5a0147 100644
> --- a/daxctl/builtin.h
> +++ b/daxctl/builtin.h
> @@ -7,4 +7,6 @@ struct daxctl_ctx;
>  int cmd_list(int argc, const char **argv, struct daxctl_ctx *ctx);
>  int cmd_migrate(int argc, const char **argv, struct daxctl_ctx *ctx);
>  int cmd_reconfig_device(int argc, const char **argv, struct daxctl_ctx *ctx);
> +int cmd_online_memory(int argc, const char **argv, struct daxctl_ctx *ctx);
> +int cmd_offline_memory(int argc, const char **argv, struct daxctl_ctx *ctx);
>  #endif /* _DAXCTL_BUILTIN_H_ */
> diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
> index e1ba7b8..1ab0732 100644
> --- a/daxctl/daxctl.c
> +++ b/daxctl/daxctl.c
> @@ -72,6 +72,8 @@ static struct cmd_struct commands[] = {
>         { "help", .d_fn = cmd_help },
>         { "migrate-device-model", .d_fn = cmd_migrate },
>         { "reconfigure-device", .d_fn = cmd_reconfig_device },
> +       { "online-memory", .d_fn = cmd_online_memory },
> +       { "offline-memory", .d_fn = cmd_offline_memory },
>  };
>
>  int main(int argc, const char **argv)
> diff --git a/daxctl/device.c b/daxctl/device.c
> index a71ebbe..64eff04 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -36,6 +36,8 @@ static unsigned long flags;
>
>  enum device_action {
>         ACTION_RECONFIG,
> +       ACTION_ONLINE,
> +       ACTION_OFFLINE,
>  };
>
>  #define BASE_OPTIONS() \
> @@ -56,6 +58,11 @@ static const struct option reconfig_options[] = {
>         OPT_END(),
>  };
>
> +static const struct option memory_options[] = {
> +       BASE_OPTIONS(),
> +       OPT_END(),
> +};
> +
>  static const char *parse_device_options(int argc, const char **argv,
>                 enum device_action action, const struct option *options,
>                 const char *usage, struct daxctl_ctx *ctx)
> @@ -76,6 +83,12 @@ static const char *parse_device_options(int argc, const char **argv,
>                 case ACTION_RECONFIG:
>                         action_string = "reconfigure";
>                         break;
> +               case ACTION_ONLINE:
> +                       action_string = "online memory for";
> +                       break;
> +               case ACTION_OFFLINE:
> +                       action_string = "offline memory for";
> +                       break;
>                 default:
>                         action_string = "<>";
>                         break;
> @@ -124,6 +137,10 @@ static const char *parse_device_options(int argc, const char **argv,
>                         }
>                 }
>                 break;
> +       case ACTION_ONLINE:
> +       case ACTION_OFFLINE:
> +               /* nothing special */
> +               break;
>         }
>         if (rc) {
>                 usage_with_options(u, options);
> @@ -286,10 +303,75 @@ static int do_reconfig(struct daxctl_dev *dev, enum dev_mode mode,
>         return rc;
>  }
>
> +static int do_xline(struct daxctl_dev *dev, enum device_action action)
> +{
> +       struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
> +       const char *devname = daxctl_dev_get_devname(dev);
> +       int rc, num_online;
> +
> +       if (!daxctl_dev_is_enabled(dev)) {

Can this fail if daxctl_dev_get_memory() succeeded?

Other than that potential code reduction looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
