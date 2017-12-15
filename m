Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E6CC22137D80
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 09:51:04 -0800 (PST)
Received: by mail-oi0-x244.google.com with SMTP id s9so6707812oie.5
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 09:55:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151260042014.3630.10551056737314097045.stgit@djiang5-desk3.ch.intel.com>
References: <151260039600.3630.12960859289293301854.stgit@djiang5-desk3.ch.intel.com>
 <151260042014.3630.10551056737314097045.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Dec 2017 09:55:45 -0800
Message-ID: <CAPcyv4iX5pfvHEiqafY=Et3O=6Rdjeivt7OQHYv2bHki5GVFfQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ndctl: add firmware download support functions in
 libndctl
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 6, 2017 at 2:47 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> Adding the DSM commands from Intel DSM v1.6 to support firmware update
> sequence in the libndctl library as additional dimm_ops.
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[..]
> +int ndctl_cmd_fw_send_set_context(struct ndctl_cmd *cmd, unsigned int context);
> +int ndctl_cmd_fw_send_set_offset(struct ndctl_cmd *cmd, unsigned int offset);
> +int ndctl_cmd_fw_send_set_length(struct ndctl_cmd *cmd, unsigned int len);
> +int ndctl_cmd_fw_send_set_data(struct ndctl_cmd *cmd, void *buf, size_t len);

These should all be input parameters to ndctl_dimm_cmd_new_fw_send()

> +int ndctl_cmd_fw_finish_set_ctrl_flags(struct ndctl_cmd *cmd, unsigned char flags);
> +int ndctl_cmd_fw_finish_set_context(struct ndctl_cmd *cmd, unsigned int context);

These should be input parameters to ndctl_dimm_cmd_new_fw_finish()

The reason the smart commands don't do this is that there may be many
and variable number of DIMM specific fields that could be set for
different DIMM types. For firmware update these parameters seem
generic / static and can be safely specified at command creation time.

> +int ndctl_cmd_fw_fquery_set_context(struct ndctl_cmd *cmd, unsigned int context);

We shouldn't need to pass around the context value it should be
inherited from the initial ndctl_dimm_cmd_new_fw_start_update()
command.

You can see an example of inheriting implied parameters from other
commands in the case of read-modify-write operations like
intel_dimm_cmd_new_smart_set_threshold() that inherits the defaults
from the result of intel_dimm_cmd_new_smart_threshold().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
