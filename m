Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03on0728.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe49::728])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 578E51A1E14
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jul 2016 11:23:59 -0700 (PDT)
Subject: Re: HPE SMART data retreival
References: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <a3a59c82-ccbb-75ac-ee21-12c58ac51d39@hpe.com>
Date: Wed, 27 Jul 2016 14:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <20160727103505.ovq7jz4553s7kc42@c203.arch.suse.de>
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
To: Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Johannes,

I hope Dan and Jerry also reply but I have recently started looking at
this too and have some comments below.

On 7/27/2016 6:35 AM, Johannes Thumshirn wrote:
> Hi Dan and Jerry,
> 
> I'm currently looking into SMART data retrieval on HPE NVDIMMs.
> 
> After the first obstacle (like getting cat
> /sys/class/nd/ndctl0/device/nmem0/commands reutrn smart so ndctl will issue
> the ioctl) I ran into a rather nasty problem. According to [1] HPEDIMMs
> need the input buffer specially crafted for SMART data, according to [2]
> Intel DIMMs don't.

It is unfortunate that the DSM functions are different for different NVDIMM

types.  There is a desire for standardization but for now this is what we have.

> Adding translation functions for the DIMMs accepted commands is one thing and
> should be more or less trivial for all DIMMs (I'll post an RFC patch as soon
> as Linus merged Dan's 4.8 pull request so I can rebase it) but doing this
> type of conversation for each and every command for every defined vendor
> family for both the input and output buffers will drive us all mad I guess.

In my opinion, I don't think we need ndctl to be able to issue every function
and decode every response but I would like to see the --health option to report
the "SMART and Health" data reported by functions 1 and 2.  I could be wrong
but I think that's all it does for the NVDIMMs that use the Intel example DSM.

There are functions in libndctl that issue other DSMs but I don't think
those aren't used by the ndctl command itself.  Whether we need the other
functions in libndctl to work with non-Intel DSM devices is still TBD.

> Especially from the distribution's POV I'm not to keen on having customers
> with some new NVDIMM family and we would need to re-implement all the
> translators again. Adding a new ID is one thing but translation tables are a
> totally different story.
> 
> So the question is have I overlooked something and there is a clean and easy
> solution to this problem, or not.

I don't think it's clean and easy today.  I think it needs to be made a bit
more modular to handle the NVDIMMs that have DSMs implemented using the
pass-through mode.

> @Jerry have you tested SMART data retrieval with ndctl? Did it work for you?

I tried it and it does not work.

-- ljk
> 
> Thanks,
> 	Johannes
> 
> [1] https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v84s.pdf
> [2] http://pmem.io/documents/NVDIMM_DSM_Interface_Example-V1.2.pdf
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
