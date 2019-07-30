Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D10F212E4B5D
 for <linux-nvdimm@lists.01.org>; Tue, 30 Jul 2019 10:49:57 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v8 07/13] daxctl: add a new reconfigure-device
 command
Date: Tue, 30 Jul 2019 17:47:25 +0000
Message-ID: <3de8c0564d45eb4ef328a48e5ff47220335886b6.camel@intel.com>
References: <20190727015212.27092-1-vishal.l.verma@intel.com>
 <20190727015212.27092-8-vishal.l.verma@intel.com>
In-Reply-To: <20190727015212.27092-8-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <5E12955DCFF07C45A95EB4E9667ABF30@intel.com>
MIME-Version: 1.0
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2019-07-26 at 19:52 -0600, Vishal Verma wrote:
> Add a new command 'daxctl-reconfigure-device'. This is used to switch
> the mode of a dax device between regular 'device_dax' and
> 'system-memory'. The command also uses the memory hotplug sysfs
> interfaces to online the newly available memory when converting to
> 'system-ram', and to attempt to offline the memory when converting back
> to a DAX device.
> 
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  daxctl/Makefile.am |   2 +
>  daxctl/builtin.h   |   1 +
>  daxctl/daxctl.c    |   1 +
>  daxctl/device.c    | 503 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 507 insertions(+)
>  create mode 100644 daxctl/device.c
> 
> +static int verify_dax_bus_model(struct daxctl_dev *dev)
> +{
> +	const char *devname = daxctl_dev_get_devname(dev);
> +	char *dev_path, *subsys_path, *resolved;
> +	struct stat sb;
> +	int rc;
> +
> +	if (asprintf(&dev_path, "/dev/%s", devname) < 0)
> +		return -ENOMEM;
> +
> +	rc = lstat(dev_path, &sb);
> +	if (rc < 0) {
> +		rc = -errno;
> +		fprintf(stderr, "%s: stat for %s failed: %s\n",
> +			devname, dev_path, strerror(-rc));
> +		goto out_dev;;
> +	}
> +
> +	if (asprintf(&subsys_path, "/sys/dev/char/%d:%d/subsystem",
> +			major(sb.st_rdev), minor(sb.st_rdev)) < 0) {
> +		rc = -ENOMEM;
> +		goto out_dev;
> +	}
> +
> +	resolved = realpath(subsys_path, NULL);
> +	if (!resolved) {
> +		rc = -errno;
> +		fprintf(stderr, "%s:  unable to determine subsys: %s\n",
> +			devname, strerror(errno));
> +		goto out_subsys;
> +	}
> +
> +	if (strcmp(resolved, "/sys/bus/dax") == 0)
> +		rc = 0;
> +	else
> +		rc = -ENXIO;
> +
> +	free(resolved);
> +out_subsys:
> +	free(subsys_path);
> +out_dev:
> +	free(dev_path);
> +	return rc;
> +}

I suspect this check is screaming to be moved into the library, and be
invoked internally by the 'enable' and 'is_enabled' routines.

When in the dax-class model, a listing of the dax device will currently
show:

{
  "chardev":"dax1.0",
  "size":799063146496,
  "target_node":3,
  "mode":"devdax",
  "state":"disabled"
}

Where the state: disabled is misleading.

I'll send a new version with this moved.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
