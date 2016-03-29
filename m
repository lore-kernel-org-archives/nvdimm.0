Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 750701A1EBD
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 13:40:00 -0700 (PDT)
Date: Tue, 29 Mar 2016 14:39:28 -0600
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: Re: [PATCH v8 00/10] nvdimm: Add an IOCTL pass thru for DSM calls
Message-ID: <20160329203928.GA37367@tevye.fc.hp.com>
References: <cover.1458583367.git.jerry.hoemann@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1458583367.git.jerry.hoemann@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Jerry.Hoemann@hpe.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 21, 2016 at 01:37:00PM -0600, Jerry Hoemann wrote:
> 
> The NVDIMM code in the kernel supports an IOCTL interface to user
> space based upon the Intel Example DSM:
> 

  [...]

> Changes in version 8:
> ---------------------
> 1. augmented family_to_uuid() to return uuid.  This to address bug
>    in prior version where acpi_nfit_ctl wasn't updating uuid
>    with value associated with command family.
> 
> 2. patch 0006 changes name of nvdimm_bus_descriptor.dsm_mask to .cmd_mask
> 
> 3. patch 0008 adds field cmd_ioctl if kernel supports full ioctl
>    as with Intel example dsm.
> 
> 4. patch 0009 make determination if kernel supports the full
>    cmd_ioctl for that dsm.  Updates the commands_show function
>    to invert the sense of display of commands.  All dsm support
>    pass-thru, only the Intel Example DSM supports the full
>    ioctl interface.
> 
> 5. patch 0010 adds explicit ioctl interface to return command mask.
>    This was done in part to avoid "unknown" command in sysfs.
> 
> 
> 

  Dan,

  Have you had a chance to look at this version?

  Thanks,

  Jerry
-- 

-----------------------------------------------------------------------------
Jerry Hoemann                  Software Engineer   Hewlett Packard Enterprise
-----------------------------------------------------------------------------
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
