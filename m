Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AAC72
	for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 23:29:45 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id e16so17718494pfc.6
        for <nvdimm@lists.linux.dev>; Mon, 20 Sep 2021 16:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VdIITPa+h+RUAqAcyjeuboukXybzolW0ivWD6AWeUMU=;
        b=X9tlk2jzFFqSeCp70vdHnCTWnmqEPXquFDjwWPOJI8unenxFU/BN/Zcr0l06PPO/Nw
         68yaK8I5y7PK0iQrFywmlFda49a7HJGTTqb4GRbCzktgHWVq2O1CjwziUGBOUTqyBQ2V
         olE3t6bDgK8vhGzW9ngMeNr0hp18YaVN6GWy+Qno6dgP3i6MVTc/04bBSI3K2HxSUsut
         D7054X0wSG1pERkhnbJiBtSNFgAQOjTwr0FLE3SDkoSHHiyB5Gp71oadlPIVyhN1fPmb
         SWT2BIz9JEk8KWmCUMiWuZ6dHF24sFGPcCnv6EgJediTXc7+OuwQXesMgQptYjHxm6aA
         VK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VdIITPa+h+RUAqAcyjeuboukXybzolW0ivWD6AWeUMU=;
        b=SxiQbP2G9ZH3FkVF95zTlTfbQnuAE9T3FAPMK+TQ9TTdCdG55dafL9ZrPPExb/pbi2
         5X5xQ7Be1Vw832/xdyyf0g3kP6tTAq9p6sgHYpcxtDa4xTryeVTbompuuwLKwZ65KGRu
         FmsSz8kRq+70mngyrQpk913D8bqVY1foKTWR/RWh0Z8XYVRvakOJT9QeycANsE29HFeU
         P+znfk1tHwAPWdtYNZMzahmHnlNUqOPxh09Oag7LVpJ0CRPryxYUbWjBnLhxC4h3drpa
         99GE3Q47O6rIsQc/+idfDQXVdisr5Lib2L+fSWv4URafXGi+YZL8lHbQIqXuF5ZBHlFK
         23kQ==
X-Gm-Message-State: AOAM5300dstcVhThzkqdZdL0/jHLip9CuX5V9Nn1wQYznzxEhYWUEsRz
	Q4HP+sI0QGoQUmS5FMXY8R2eF1vldouWWwATZuKMNw==
X-Google-Smtp-Source: ABdhPJxn4C76fLh6bn5Au+td56tzpPGHrUMWl9Eu9RjmbbiNq8TyPELKCaIaZ9A+uEFKfwgHII0LOr1njoqPscbuGoo=
X-Received: by 2002:a63:3545:: with SMTP id c66mr25377409pga.377.1632180584639;
 Mon, 20 Sep 2021 16:29:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210920072726.1159572-3-hch@lst.de> <202109210155.7rqblE6U-lkp@intel.com>
In-Reply-To: <202109210155.7rqblE6U-lkp@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Sep 2021 16:29:33 -0700
Message-ID: <CAPcyv4gPf74k7Lz8Uh2ni1bv7Po3pDPyBr24w4ea6ZzdvRjOQw@mail.gmail.com>
Subject: Re: [PATCH 2/3] nvdimm/pmem: move dax_attribute_group from dax to pmem
To: kernel test robot <lkp@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, kbuild-all@lists.01.org, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, linux-block@vger.kernel.org, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 20, 2021 at 11:01 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Christoph,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on axboe-block/for-next]
> [also build test ERROR on linus/master v5.15-rc2 next-20210920]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Christoph-Hellwig/nvdimm-pmem-fix-creating-the-dax-group/20210920-162804
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
> config: riscv-buildonly-randconfig-r006-20210920 (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/1a16d0f32f70bcd159a9f8cf32794f4024e8711e
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Christoph-Hellwig/nvdimm-pmem-fix-creating-the-dax-group/20210920-162804
>         git checkout 1a16d0f32f70bcd159a9f8cf32794f4024e8711e
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=riscv
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/dax/super.c:375:6: error: no previous prototype for 'run_dax' [-Werror=missing-prototypes]
>      375 | void run_dax(struct dax_device *dax_dev)
>          |      ^~~~~~~

In this new -Werror world drivers/dax/bus.c needs:

#include "bus.h"

> >> drivers/dax/super.c:70:27: error: 'dax_get_by_host' defined but not used [-Werror=unused-function]
>       70 | static struct dax_device *dax_get_by_host(const char *host)
>          |                           ^~~~~~~~~~~~~~~
>    cc1: all warnings being treated as errors

Nice additional cleanup that now fs_dax_get_by_bdev() is the only
caller of dax_get_by_host().
