Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it1-x142.google.com (mail-it1-x142.google.com
 [IPv6:2607:f8b0:4864:20::142])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BDE4121163246
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 15:24:59 -0700 (PDT)
Received: by mail-it1-x142.google.com with SMTP id q70-v6so10563268itb.3
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 15:24:59 -0700 (PDT)
MIME-Version: 1.0
References: <20181010060812.20068-1-oohall@gmail.com>
 <20181010060812.20068-2-oohall@gmail.com>
 <857573fb-6839-000b-a64a-c020b0d8faea@linux.vnet.ibm.com>
In-Reply-To: <857573fb-6839-000b-a64a-c020b0d8faea@linux.vnet.ibm.com>
From: Oliver <oohall@gmail.com>
Date: Thu, 11 Oct 2018 09:24:47 +1100
Message-ID: <CAOSf1CGkgwSwrpWX7WBgix8sVh+keBmtk9kxZOU3Ha0LZ0h=dw@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc/pseries: PAPR persistent memory support
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
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 11, 2018 at 3:36 AM Nathan Fontenot
<nfont@linux.vnet.ibm.com> wrote:
>
> On 10/10/2018 01:08 AM, Oliver O'Halloran wrote:
> > This patch implements support for discovering storage class memory
> > devices at boot and for handling hotplug of new regions via RTAS
> > hotplug events.
> >
> > Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> > ---
> >  arch/powerpc/include/asm/firmware.h       |  3 ++-
> >  arch/powerpc/include/asm/hvcall.h         | 10 +++++++++-
> >  arch/powerpc/include/asm/rtas.h           |  2 ++
> >  arch/powerpc/kernel/rtasd.c               |  2 ++
> >  arch/powerpc/platforms/pseries/Makefile   |  2 +-
> >  arch/powerpc/platforms/pseries/dlpar.c    |  4 ++++
> >  arch/powerpc/platforms/pseries/firmware.c |  1 +
> >  arch/powerpc/platforms/pseries/pseries.h  |  5 +++++
> >  arch/powerpc/platforms/pseries/ras.c      |  3 ++-
> >  9 files changed, 28 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/firmware.h b/arch/powerpc/include/asm/firmware.h
> > index 7a051bd21f87..113c64d5d394 100644
> > --- a/arch/powerpc/include/asm/firmware.h
> > +++ b/arch/powerpc/include/asm/firmware.h
> > @@ -52,6 +52,7 @@
> >  #define FW_FEATURE_PRRN              ASM_CONST(0x0000000200000000)
> >  #define FW_FEATURE_DRMEM_V2  ASM_CONST(0x0000000400000000)
> >  #define FW_FEATURE_DRC_INFO  ASM_CONST(0x0000000800000000)
> > +#define FW_FEATURE_PAPR_SCM  ASM_CONST(0x0000001000000000)
> >
> >  #ifndef __ASSEMBLY__
> >
> > @@ -69,7 +70,7 @@ enum {
> >               FW_FEATURE_SET_MODE | FW_FEATURE_BEST_ENERGY |
> >               FW_FEATURE_TYPE1_AFFINITY | FW_FEATURE_PRRN |
> >               FW_FEATURE_HPT_RESIZE | FW_FEATURE_DRMEM_V2 |
> > -             FW_FEATURE_DRC_INFO,
> > +             FW_FEATURE_DRC_INFO | FW_FEATURE_PAPR_SCM,
> >       FW_FEATURE_PSERIES_ALWAYS = 0,
> >       FW_FEATURE_POWERNV_POSSIBLE = FW_FEATURE_OPAL,
> >       FW_FEATURE_POWERNV_ALWAYS = 0,
> > diff --git a/arch/powerpc/include/asm/hvcall.h b/arch/powerpc/include/asm/hvcall.h
> > index a0b17f9f1ea4..0e81ef83b35a 100644
> > --- a/arch/powerpc/include/asm/hvcall.h
> > +++ b/arch/powerpc/include/asm/hvcall.h
> > @@ -295,7 +295,15 @@
> >  #define H_INT_ESB               0x3C8
> >  #define H_INT_SYNC              0x3CC
> >  #define H_INT_RESET             0x3D0
> > -#define MAX_HCALL_OPCODE     H_INT_RESET
> > +#define H_SCM_READ_METADATA     0x3E4
> > +#define H_SCM_WRITE_METADATA    0x3E8
> > +#define H_SCM_BIND_MEM          0x3EC
> > +#define H_SCM_UNBIND_MEM        0x3F0
> > +#define H_SCM_QUERY_BLOCK_MEM_BINDING 0x3F4
> > +#define H_SCM_QUERY_LOGICAL_MEM_BINDING 0x3F8
> > +#define H_SCM_MEM_QUERY              0x3FC
> > +#define H_SCM_BLOCK_CLEAR       0x400
> > +#define MAX_HCALL_OPCODE     H_SCM_BLOCK_CLEAR
> >
> >  /* H_VIOCTL functions */
> >  #define H_GET_VIOA_DUMP_SIZE 0x01
> > diff --git a/arch/powerpc/include/asm/rtas.h b/arch/powerpc/include/asm/rtas.h
> > index 71e393c46a49..1e81f3d55457 100644
> > --- a/arch/powerpc/include/asm/rtas.h
> > +++ b/arch/powerpc/include/asm/rtas.h
> > @@ -125,6 +125,7 @@ struct rtas_suspend_me_data {
> >  #define RTAS_TYPE_INFO                       0xE2
> >  #define RTAS_TYPE_DEALLOC            0xE3so we might as well
> >  #define RTAS_TYPE_DUMP                       0xE4
> > +#define RTAS_TYPE_HOTPLUG            0xE5
> >  /* I don't add PowerMGM events right now, this is a different topic */
> >  #define RTAS_TYPE_PMGM_POWER_SW_ON   0x60
> >  #define RTAS_TYPE_PMGM_POWER_SW_OFF  0x61
> > @@ -316,6 +317,7 @@ struct pseries_hp_errorlog {
> >  #define PSERIES_HP_ELOG_RESOURCE_MEM 2
> >  #define PSERIES_HP_ELOG_RESOURCE_SLOT        3
> >  #define PSERIES_HP_ELOG_RESOURCE_PHB 4
> > +#define PSERIES_HP_ELOG_RESOURCE_PMEM   6
> >
> >  #define PSERIES_HP_ELOG_ACTION_ADD   1
> >  #define PSERIES_HP_ELOG_ACTION_REMOVE        2
> > diff --git a/arch/powerpc/kernel/rtasd.c b/arch/powerpc/kernel/rtasd.c
> > index 6fafc82c04b0..fad0baddfcba 100644
> > --- a/arch/powerpc/kernel/rtasd.c
> > +++ b/arch/powerpc/kernel/rtasd.c
> > @@ -91,6 +91,8 @@ static char *rtas_event_type(int type)
> >                       return "Dump Notification Event";
> >               case RTAS_TYPE_PRRN:
> >                       return "Platform Resource Reassignment Event";
> > +             case RTAS_TYPE_HOTPLUG:
> > +                     return "Hotplug Event";
> >       }
> >
> >       return rtas_type[0];
> > diff --git a/arch/powerpc/platforms/pseries/Makefile b/arch/powerpc/platforms/pseries/Makefile
> > index 7e89d5c47068..892b27ced973 100644
> > --- a/arch/powerpc/platforms/pseries/Makefile
> > +++ b/arch/powerpc/platforms/pseries/Makefile
> > @@ -13,7 +13,7 @@ obj-$(CONFIG_KEXEC_CORE)    += kexec.o
> >  obj-$(CONFIG_PSERIES_ENERGY) += pseries_energy.o
> >
> >  obj-$(CONFIG_HOTPLUG_CPU)    += hotplug-cpu.o
> > -obj-$(CONFIG_MEMORY_HOTPLUG) += hotplug-memory.o
> > +obj-$(CONFIG_MEMORY_HOTPLUG) += hotplug-memory.o pmem.o
> >
> >  obj-$(CONFIG_HVC_CONSOLE)    += hvconsole.o
> >  obj-$(CONFIG_HVCS)           += hvcserver.o
> > diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
> > index a0b20c03f078..795996fefdb9 100644
> > --- a/arch/powerpc/platforms/pseries/dlpar.c
> > +++ b/arch/powerpc/platforms/pseries/dlpar.c
> > @@ -357,6 +357,10 @@ static int handle_dlpar_errorlog(struct pseries_hp_errorlog *hp_elog)
> >       case PSERIES_HP_ELOG_RESOURCE_CPU:
> >               rc = dlpar_cpu(hp_elog);
> >               break;
> > +     case PSERIES_HP_ELOG_RESOURCE_PMEM:
> > +             rc = dlpar_hp_pmem(hp_elog);
>
> You reference a dlpar handler for pmem here but I am not finding a handler
> defined when CONFIG_MEMORY_HOTPLUG is defined. The update to pseries.h below
> only provides a definition when it is not defined.

Ah crap. The file that adds it went missing when I rebased. I'll post a respin.

> Also, do we need to handle dlpar of pmem memory? There have been discussion of
> supporting this in the future but I did not thin it was currently supported.

I think it's something that we're going to need and Barata has already
implemented support for it inside of qemu. The implementation is more
or less the same in the hot and coldplug cases so it's not much work
to support it.

> -Nathan
>
> > +             break;
> > +
> >       default:
> >               pr_warn_ratelimited("Invalid resource (%d) specified\n",
> >                                   hp_elog->resource);
> > diff --git a/arch/powerpc/platforms/pseries/firmware.c b/arch/powerpc/platforms/pseries/firmware.c
> > index a3bbeb43689e..4927de57d8ee 100644
> > --- a/arch/powerpc/platforms/pseries/firmware.c
> > +++ b/arch/powerpc/platforms/pseries/firmware.c
> > @@ -65,6 +65,7 @@ hypertas_fw_features_table[] = {
> >       {FW_FEATURE_SET_MODE,           "hcall-set-mode"},
> >       {FW_FEATURE_BEST_ENERGY,        "hcall-best-energy-1*"},
> >       {FW_FEATURE_HPT_RESIZE,         "hcall-hpt-resize"},
> > +     {FW_FEATURE_PAPR_SCM,           "hcall-scm"},
> >  };
> >
> >  /* Build up the firmware features bitmask using the contents of
> > diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
> > index 60db2ee511fb..d0829677c896 100644
> > --- a/arch/powerpc/platforms/pseries/pseries.h
> > +++ b/arch/powerpc/platforms/pseries/pseries.h
> > @@ -63,11 +63,16 @@ void queue_hotplug_event(struct pseries_hp_errorlog *hp_errlog,
> >                        struct completion *hotplug_done, int *rc);
> >  #ifdef CONFIG_MEMORY_HOTPLUG
> >  int dlpar_memory(struct pseries_hp_errorlog *hp_elog);
> > +int dlpar_hp_pmem(struct pseries_hp_errorlog *hp_elog);
> >  #else
> >  static inline int dlpar_memory(struct pseries_hp_errorlog *hp_elog)
> >  {
> >       return -EOPNOTSUPP;
> >  }
> > +int dlpar_hp_pmem(struct pseries_hp_errorlog *hp_elog)
> > +{
> > +     return -EOPNOTSUPP;
> > +};
> >  #endif
> >
> >  #ifdef CONFIG_HOTPLUG_CPU
> > diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
> > index 851ce326874a..ae22fc007276 100644
> > --- a/arch/powerpc/platforms/pseries/ras.c
> > +++ b/arch/powerpc/platforms/pseries/ras.c
> > @@ -237,7 +237,8 @@ static irqreturn_t ras_hotplug_interrupt(int irq, void *dev_id)
> >        * hotplug events on the ras_log_buf to be handled by rtas_errd.
> >        */
> >       if (hp_elog->resource == PSERIES_HP_ELOG_RESOURCE_MEM ||
> > -         hp_elog->resource == PSERIES_HP_ELOG_RESOURCE_CPU)
> > +         hp_elog->resource == PSERIES_HP_ELOG_RESOURCE_CPU ||
> > +         hp_elog->resource == PSERIES_HP_ELOG_RESOURCE_PMEM)
> >               queue_hotplug_event(hp_elog, NULL, NULL);
> >       else
> >               log_error(ras_log_buf, ERR_TYPE_RTAS_LOG, 0);
> >
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
