Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22806AA0
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 17:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658338719; x=1689874719;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UjfLlFcx9askUaChpUiLM7L/nzE6n3G9Z7tIQRQ64Cc=;
  b=E6MfgXtYQO9V0yghurp1IIZcs3H566JO0hYt+80qWWAgT48VDS/vAdAi
   quxa0trPtLhJNHmHeMKflVJlHhxfmtIs/js53A6BffL3a1je82JW6+bgY
   SYQKS6xAbKen/CeoHSn41g7zX+eJ/Niv8WCfMMSlcR4qz3zCgv6ig7vRb
   9HzLQn2seCiCnOILIBC35cO9pp+3AxaBx5pmna+mwGgHTf+wc11alFwQx
   m3JEa9J8+iRYQ7q68DwQhiceww5Udkh0DotKrBbXY3qIJIagWmMF22qGM
   nRdBdQqzMyhTM+NcDrWNQ9/HTqCm3ZUTqvkzGhU5KFjLUZQqlTayI/rD3
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="286851881"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="286851881"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 10:38:38 -0700
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="925316501"
Received: from mwitcher-mobl.amr.corp.intel.com (HELO [10.212.89.37]) ([10.212.89.37])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 10:38:38 -0700
Message-ID: <d595bc58-7305-7f27-4ec0-218eb6492fd3@intel.com>
Date: Wed, 20 Jul 2022 10:38:37 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH RFC 13/15] cxl/pmem: Add "Passphrase Secure Erase"
 security command support
Content-Language: en-US
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com,
 a.manzanares@samsung.com
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791938847.2491387.8701829648751368015.stgit@djiang5-desk3.ch.intel.com>
 <20220720061727.ufygesevkonmeelr@offworld>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20220720061727.ufygesevkonmeelr@offworld>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/19/2022 11:17 PM, Davidlohr Bueso wrote:
> On Fri, 15 Jul 2022, Dave Jiang wrote:
>
>> Create callback function to support the nvdimm_security_ops() ->erase()
>> callback. Translate the operation to send "Passphrase Secure Erase"
>> security command for CXL memory device.
>>
>> When the mem device is secure erased, arch_invalidate_nvdimm_cache() is
>> called in order to invalidate all CPU caches before attempting to access
>> the mem device again.
>>
>> See CXL 2.0 spec section 8.2.9.5.6.6 for reference.
>
> So something like the below is what I picture for 8.2.9.5.5.2
> (I'm still thinking about the background command polling semantics
> and corner cases for the overwrite/sanitize - also needed for
> scan media - so I haven't implemented 8.2.9.5.5.1, but should
> otherwise be straightforward).
>
> The use cases here would be:
>
> $> cxl sanitize --crypto-erase memN
> $> cxl sanitize --overwrite memN
> $> cxl sanitize --wait-overwrite memN
>
> While slightly out of the scope of this series, it still might be
> worth carrying as they are that unrelated unless there is something
> fundamentally with my approach.

Patch below is about what I had in mind for the secure erase command. 
Looks good to me. The only thing I think it needs is to make sure the 
mem devs are not "in use" before secure erase in addition to the 
security check that's already there below. I was planning on working on 
this after getting the current security commands series wrapped up. But 
if you are already developing this then I'll defer.

Also here's the latest code that I'm still going through testing if you 
want to play with it. I still need to replace the x86 patch with your 
version.

https://git.kernel.org/pub/scm/linux/kernel/git/djiang/linux.git/log/?h=cxl-security


>
> Thanks,
> Davidlohr
>
> -----<8----------------------------------------------------
> [PATCH 16/15] cxl/mbox: Add "Secure Erase" security command support
>
> To properly support this feature, create a 'security' sysfs
> file that when read will list the current pmem security state,
> and when written to, perform the requested operation (only
> secure erase is currently supported).
>
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> ---
>  Documentation/ABI/testing/sysfs-bus-cxl | 13 +++++++
>  drivers/cxl/core/mbox.c                 | 44 +++++++++++++++++++++
>  drivers/cxl/core/memdev.c               | 51 +++++++++++++++++++++++++
>  drivers/cxl/cxlmem.h                    |  3 ++
>  4 files changed, 111 insertions(+)
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-cxl 
> b/Documentation/ABI/testing/sysfs-bus-cxl
> index 7c2b846521f3..ca5216b37bcf 100644
> --- a/Documentation/ABI/testing/sysfs-bus-cxl
> +++ b/Documentation/ABI/testing/sysfs-bus-cxl
> @@ -52,6 +52,19 @@ Description:
>          host PCI device for this memory device, emit the CPU node
>          affinity for this device.
>
> +What:        /sys/bus/cxl/devices/memX/security
> +Date:        July, 2022
> +KernelVersion:    v5.21
> +Contact:    linux-cxl@vger.kernel.org
> +Description:
> +        Reading this file will display the security state for that
> +        device. The following states are available: disabled, frozen,
> +        locked and unlocked. When writing to the file, the following
> +        command(s) are supported:
> +        erase - Secure Erase user data by changing the media encryption
> +            keys for all user data areas of the device. This causes
> +            all CPU caches to be flushed.
> +
>  What:        /sys/bus/cxl/devices/*/devtype
>  Date:        June, 2021
>  KernelVersion:    v5.14
> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 54f434733b56..54b4aec615ee 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c
> @@ -787,6 +787,50 @@ int cxl_dev_state_identify(struct cxl_dev_state 
> *cxlds)
>  }
>  EXPORT_SYMBOL_NS_GPL(cxl_dev_state_identify, CXL);
>
> +/**
> + * cxl_mem_sanitize() - Send sanitation related commands to the device.
> + * @cxlds: The device data for the operation
> + * @cmd: The command opcode to send
> + *
> + * Return: 0 if the command was executed successfully, regardless of
> + * whether or not the actual security operation is done in the 
> background.
> + * Upon error, return the result of the mailbox command or -EINVAL if
> + * security requirements are not met.
> + *
> + * See CXL 2.0 @8.2.9.5.5 Sanitize.
> + */
> +int cxl_mem_sanitize(struct cxl_dev_state *cxlds, enum cxl_opcode cmd)
> +{
> +    int rc;
> +    u32 sec_out;
> +
> +    /* TODO: CXL_MBOX_OP_SECURE_SANITIZE */
> +    if (cmd != CXL_MBOX_OP_SECURE_ERASE)
> +        return -EINVAL;
> +
> +    rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_GET_SECURITY_STATE,
> +                   NULL, 0, &sec_out, sizeof(sec_out));
> +    if (rc)
> +        return rc;
> +    /*
> +     * Prior to using these commands, any security applied to
> +     * the user data areas of the device shall be DISABLED (or
> +     * UNLOCKED for secure erase case).
> +     */
> +    if (sec_out & CXL_PMEM_SEC_STATE_USER_PASS_SET ||
> +        sec_out & CXL_PMEM_SEC_STATE_LOCKED)
> +        return -EINVAL;
> +
> +    rc = cxl_mbox_send_cmd(cxlds, cmd, NULL, 0, NULL, 0);
> +    if (rc == 0) {
> +        /* flush all CPU caches before we read it */
> +        flush_cache_all();
> +    }
> +
> +    return rc;
> +}
> +EXPORT_SYMBOL_NS_GPL(cxl_mem_sanitize, CXL);
> +
>  int cxl_mem_create_range_info(struct cxl_dev_state *cxlds)
>  {
>      int rc;
> diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
> index f7cdcd33504a..13563facfd62 100644
> --- a/drivers/cxl/core/memdev.c
> +++ b/drivers/cxl/core/memdev.c
> @@ -106,12 +106,63 @@ static ssize_t numa_node_show(struct device 
> *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(numa_node);
>
> +#define CXL_SEC_CMD_SIZE 32
> +
> +static ssize_t security_show(struct device *dev,
> +                 struct device_attribute *attr, char *buf)
> +{
> +    struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +    struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +    u32 sec_out;
> +    int rc;
> +
> +    rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_GET_SECURITY_STATE,
> +                   NULL, 0, &sec_out, sizeof(sec_out));
> +    if (rc)
> +        return rc;
> +
> +    if (!(sec_out & CXL_PMEM_SEC_STATE_USER_PASS_SET))
> +        return sprintf(buf, "disabled\n");
> +    if (sec_out & CXL_PMEM_SEC_STATE_FROZEN)
> +        return sprintf(buf, "frozen\n");
> +    if (sec_out & CXL_PMEM_SEC_STATE_LOCKED)
> +        return sprintf(buf, "locked\n");
> +    else
> +        return sprintf(buf, "unlocked\n");
> +}
> +
> +static ssize_t security_store(struct device *dev,
> +                  struct device_attribute *attr,
> +                  const char *buf, size_t len)
> +{
> +    struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
> +    struct cxl_dev_state *cxlds = cxlmd->cxlds;
> +    char cmd[CXL_SEC_CMD_SIZE+1];
> +    ssize_t rc;
> +
> +    rc = sscanf(buf, "%"__stringify(CXL_SEC_CMD_SIZE)"s", cmd);
> +    if (rc < 1)
> +        return -EINVAL;
> +
> +    if (sysfs_streq(cmd, "erase")) {
> +        dev_dbg(dev, "secure-erase\n");
> +        rc = cxl_mem_sanitize(cxlds, CXL_MBOX_OP_SECURE_ERASE);
> +    } else
> +        rc = -EINVAL;
> +
> +    if (rc == 0)
> +        rc = len;
> +    return rc;
> +}
> +static DEVICE_ATTR_RW(security);
> +
>  static struct attribute *cxl_memdev_attributes[] = {
>      &dev_attr_serial.attr,
>      &dev_attr_firmware_version.attr,
>      &dev_attr_payload_max.attr,
>      &dev_attr_label_storage_size.attr,
>      &dev_attr_numa_node.attr,
> +    &dev_attr_security.attr,
>      NULL,
>  };
>
> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> index a375a69040d2..cd6650ff757f 100644
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h
> @@ -250,6 +250,7 @@ enum cxl_opcode {
>      CXL_MBOX_OP_GET_SCAN_MEDIA_CAPS    = 0x4303,
>      CXL_MBOX_OP_SCAN_MEDIA        = 0x4304,
>      CXL_MBOX_OP_GET_SCAN_MEDIA    = 0x4305,
> +    CXL_MBOX_OP_SECURE_ERASE        = 0x4401,
>      CXL_MBOX_OP_GET_SECURITY_STATE    = 0x4500,
>      CXL_MBOX_OP_SET_PASSPHRASE    = 0x4501,
>      CXL_MBOX_OP_DISABLE_PASSPHRASE    = 0x4502,
> @@ -348,6 +349,8 @@ struct cxl_mem_command {
>  #define CXL_CMD_FLAG_FORCE_ENABLE BIT(0)
>  };
>
> +int cxl_mem_sanitize(struct cxl_dev_state *cxlds, enum cxl_opcode cmd);
> +
>  #define CXL_PMEM_SEC_STATE_USER_PASS_SET    0x01
>  #define CXL_PMEM_SEC_STATE_MASTER_PASS_SET    0x02
>  #define CXL_PMEM_SEC_STATE_LOCKED        0x04
