Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13083211A206A
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 17:57:58 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id a77so3360331oii.5
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 17:57:58 -0800 (PST)
MIME-Version: 1.0
References: <154474458351.64529.4227918957466268448.stgit@djiang5-desk3.ch.intel.com>
 <154474488280.64529.6119357447220632023.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154474488280.64529.6119357447220632023.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 13 Dec 2018 17:57:46 -0800
Message-ID: <CAPcyv4ie9O7P0RTL+Cvs+Dro6wRCgAHip_vLBAWYc+DMY8zvDg@mail.gmail.com>
Subject: Re: [PATCH v15 01/16] acpi/nfit: Add support for Intel DSM 1.8
 commands
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 13, 2018 at 3:48 PM Dave Jiang <dave.jiang@intel.com> wrote:
>
> Add command definition for security commands defined in Intel DSM
> specification v1.8 [1]. This includes "get security state", "set
> passphrase", "unlock unit", "freeze lock", "secure erase", "overwrite",
> "overwrite query", "master passphrase enable/disable", and "master
> erase", . Since this adds several Intel definitions, move the relevant
> bits to their own header.
>
> These commands mutate physical data, but that manipulation is not cache
> coherent. The requirement to flush and invalidate caches makes these
> commands unsuitable to be called from userspace, so extra logic is added
> to detect and block these commands from being submitted via the ioctl
> command submission path.
>
> Lastly, the commands may contain sensitive key material that should not
> be dumped in a standard debug session. Update the nvdimm-command
> payload-dump facility to move security command payloads behind a
> default-off compile time switch.
>
> [1]: http://pmem.io/documents/NVDIMM_DSM_Interface-V1.8.pdf
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[..]
>  int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>                 unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc)
>  {
> @@ -478,9 +496,10 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>
>         dev_dbg(dev, "%s cmd: %d: func: %d input length: %d\n",
>                 dimm_name, cmd, func, in_buf.buffer.length);
> -       print_hex_dump_debug("nvdimm in  ", DUMP_PREFIX_OFFSET, 4, 4,
> -                       in_buf.buffer.pointer,
> -                       min_t(u32, 256, in_buf.buffer.length), true);
> +       if (payload_dumpable(nfit_mem->family, func))

My bad, this crashes because nfit_mem is of course NULL when
acpi_nfit_ctl() is processing a bus level command like
ND_CMD_ARS_STATUS.

...I believe you had it correct in an earlier version and I lost that
in the squash.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
