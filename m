Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5A98211B1F85
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 09:08:22 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id 81so4149881otj.2
 for <linux-nvdimm@lists.01.org>; Tue, 08 Jan 2019 09:08:22 -0800 (PST)
MIME-Version: 1.0
References: <20190108083423.6996-1-jthumshirn@suse.de>
In-Reply-To: <20190108083423.6996-1-jthumshirn@suse.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Jan 2019 09:08:10 -0800
Message-ID: <CAPcyv4iogcyUwnpangOmKNVGuGzUXhRPcrCwc-BehxvJsYS8LA@mail.gmail.com>
Subject: Re: [PATCH] ndctl, monitor: use type=simple instead of type=forking
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 8, 2019 at 12:34 AM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> There is no need to use Type=forking for 'ndctl monitor', Type=simple is
> sufficient.
>
> When we use Type=forking and try to run ndctl monitor on a machine without
> pmem we even get the following error in the journal:
>
> Jan 07 13:34:54 bragi systemd[1]: Starting Ndctl Monitor Daemon...
> Jan 07 13:34:54 bragi ndctl[13776]: custom logging function 0x55ea57d60250 registered
> Jan 07 13:34:54 bragi systemd[1]: Started Ndctl Monitor Daemon.
> Jan 07 13:34:54 bragi ndctl[13777]: ndctl monitor daemon started
> Jan 07 13:34:54 bragi kill[13778]: kill: cannot find process ""
> Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Control process exited, code=exited status=1
> Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Unit entered failed state.
> Jan 07 13:34:54 bragi systemd[1]: ndctl-monitor.service: Failed with result 'exit-code'.
>
> This is because the daemon exits and systemd is not able to determine
> $MAINPID anymore.
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
