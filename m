Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x242.google.com (mail-pl0-x242.google.com
 [IPv6:2607:f8b0:400e:c01::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62FE92097F544
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 16:26:29 -0700 (PDT)
Received: by mail-pl0-x242.google.com with SMTP id e11-v6so1125427plb.3
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 16:26:29 -0700 (PDT)
Date: Tue, 17 Jul 2018 16:26:26 -0700
From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v5 00/12] Adding security support for nvdimm
Message-ID: <20180717232626.GA176997@gmail.com>
References: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
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
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 17, 2018 at 01:54:04PM -0700, Dave Jiang wrote:
> The following series implements security support for nvdimm. Mostly adding
> new security DSM support from the Intel NVDIMM DSM spec v1.7, but also
> adding generic support libnvdimm for other vendors. The most important
> security features are unlocking locked nvdimms, and updating/setting security
> passphrase to nvdimms.
> 
> Security folks, thanks in advance for taking a look at my key management
> implementation and making sure that I'm doing something sane. Mainly you'll
> want to review patches 2, 4, 5, and 6 as most relevant ones that need scrutiny.
> 
> v5:
> - Moved dimm_id initialization (Dan)
> - Added a key_put_sync() in order to run key_gc_work and cleanup old key. (Dan)
> - Added check to block security state changes while DIMM is active. (Dan)
> 
> v4:
> - flip payload layout for update passphrase to make it easier on userland.
> 
> v3:
> - Set x86 wrappers for x86 only bits. (Dan)
> - Fixed up some verbiage in commit headers.
> - Put in usage of sysfs_streq() for sysfs inputs.
> - 0-day build fixes for non-x86 archs.
> 
> v2:
> - Move inclusion of intel.h to relevant source files and not in nfit.h. (Dan)
> - Moved security ring relevant code to dimm_devs.c. (Dan)
> - Added dimm_id to nfit_mem to avoid recreate per sysfs show call. (Dan)
> - Added routine to return security_ops based on family supplied. (Dan)
> - Added nvdimm_key_data struct to wrap raw passphrase string. (Dan)
> - Allocate firmware package on stack. (Dan)
> - Added missing frozen state detection when retrieving security state.
> 
> ---
> 
> Dave Jiang (12):
>       nfit: add support for Intel DSM 1.7 commands
>       libnvdimm: create keyring to store security keys
>       nfit/libnvdimm: store dimm id as a member to struct nvdimm
>       nfit/libnvdimm: add unlock of nvdimm support for Intel DIMMs
>       keys: add call key_put_sync() to flush key_gc_work when doing a key_put().
>       nfit/libnvdimm: add set passphrase support for Intel nvdimms
>       nfit/libnvdimm: add disable passphrase support to Intel nvdimm.
>       nfit/libnvdimm: add freeze security support to Intel nvdimm
>       nfit/libnvdimm: add support for issue secure erase DSM to Intel nvdimm
>       nfit_test: add context to dimm_dev for nfit_test
>       nfit_test: add test support for Intel nvdimm security DSMs
>       libnvdimm: add documentation for nvdimm security support
> 
> 
>  Documentation/nvdimm/security    |   70 ++++++
>  drivers/acpi/nfit/Makefile       |    1 
>  drivers/acpi/nfit/core.c         |   58 ++++-
>  drivers/acpi/nfit/intel.c        |  366 ++++++++++++++++++++++++++++++++
>  drivers/acpi/nfit/intel.h        |   83 +++++++
>  drivers/acpi/nfit/nfit.h         |   20 ++
>  drivers/nvdimm/bus.c             |    2 
>  drivers/nvdimm/core.c            |    7 +
>  drivers/nvdimm/dimm.c            |    7 +
>  drivers/nvdimm/dimm_devs.c       |  430 ++++++++++++++++++++++++++++++++++++++
>  drivers/nvdimm/nd-core.h         |    4 
>  drivers/nvdimm/nd.h              |    2 
>  include/linux/key.h              |    1 
>  include/linux/libnvdimm.h        |   41 +++-
>  security/keys/key.c              |   35 +++
>  tools/testing/nvdimm/Kbuild      |    1 
>  tools/testing/nvdimm/test/nfit.c |  227 +++++++++++++++++++-
>  17 files changed, 1315 insertions(+), 40 deletions(-)
>  create mode 100644 Documentation/nvdimm/security
>  create mode 100644 drivers/acpi/nfit/intel.c
>  create mode 100644 drivers/acpi/nfit/intel.h
> 

Which git tree does this series apply to?  I tried upstream, linux-next, and
linux-block/for-next, but in all cases patch 4 doesn't apply:

Applying: nfit: add support for Intel DSM 1.7 commands
Applying: libnvdimm: create keyring to store security keys
Applying: nfit/libnvdimm: store dimm id as a member to struct nvdimm
Applying: nfit/libnvdimm: add unlock of nvdimm support for Intel DIMMs
error: sha1 information is lacking or useless (drivers/acpi/nfit/core.c).
error: could not build fake ancestor
Patch failed at 0004 nfit/libnvdimm: add unlock of nvdimm support for Intel DIMMs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
