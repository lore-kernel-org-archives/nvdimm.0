Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com
 [IPv6:2607:f8b0:4864:20::330])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0767208AE344
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 08:34:33 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id i20so17547602otl.0
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 08:34:33 -0800 (PST)
MIME-Version: 1.0
References: <20190215095710.GA12279@linux-x5ow.site>
In-Reply-To: <20190215095710.GA12279@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Feb 2019 08:34:22 -0800
Message-ID: <CAPcyv4ha4u4Fekee0oKqCTxYrySJEAMW3kVuHsTGHgw7i+5N5w@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Software RAID Support for NV-DIMM
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lsf-pc@lists.linux-foundation.org, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 15, 2019 at 1:57 AM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> (This is a joint proposal with Hannes Reinecke)
>
> Servers with NV-DIMM are slowly emerging in data centers but one key feature
> for reliability of these systems hasn't been addressed up to now, data
> redundancy.
>
> While it would be best to solve this issue in the memory controller of the CPU
> itself, I don't see this coming in the next few years. This puts us as the OS
> in the burden to create the redundant copies of data for the users.
>
> If we leave of the DAX support Linux' software RAID implementations (MD,
> device-mapper and BTRFS RAID) do already work on top of pmem devices, but they
> are incompatible with DAX.
>
> In this session Hannes and I would like to discuss eventual ways how we as an
> operating system can mitigate these issues for our users.

One feature request I have heard in this space is to at least have
filesystem metadata redundancy for DAX. For applications that can
handle their own data-replication the single-point-of-failure FS
metadata becomes a larger liability.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
