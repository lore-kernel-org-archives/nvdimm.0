Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C611D2C1
	for <nvdimm@lists.linux.dev>; Thu, 22 Jun 2023 14:38:11 +0000 (UTC)
Received: from ed3e173716be.home.arpa (unknown [124.16.138.129])
	by APP-03 (Coremail) with SMTP id rQCowABHT2fJXJRkDIXGAg--.21888S2;
	Thu, 22 Jun 2023 22:38:02 +0800 (CST)
From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
To: ira.weiny@intel.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	oohall@gmail.com,
	aneesh.kumar@linux.ibm.com
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: Re: [PATCH] libnvdimm/of_pmem: Add check and kfree for kstrdup
Date: Thu, 22 Jun 2023 22:38:00 +0800
Message-Id: <20230622143800.31779-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABHT2fJXJRkDIXGAg--.21888S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WFWDAw1kJF4UKr4xXFy7Jrb_yoW8ArW8p3
	y8JF13CrWkJF4a9ws2v3WY9a1Yvw4ktFy8Wa4Dt3srXFn0vr17ZryrJryjgrs3uFy0kw1I
	yFWUJa1agry5ArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
	0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW5
	XwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUXiSdUUUUU=
X-Originating-IP: [124.16.138.129]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/

On Wed, Jun 21, 2023 at 00:04:36 +0800, Ira Weiny wrote:
> Ira Weiny wrote:
>> Jiasheng Jiang wrote:
>> > Add check for the return value of kstrdup() and return the error
>> > if it fails in order to avoid NULL pointer dereference.
>> > Moreover, use kfree() in the later error handling in order to avoid
>> > memory leak.
>> > 
>> > Fixes: 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique name for bus provider")
>> > Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>> > ---
>> >  drivers/nvdimm/of_pmem.c | 6 ++++++
>> >  1 file changed, 6 insertions(+)
>> > 
>> > diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
>> > index 10dbdcdfb9ce..fe6edb7e6631 100644
>> > --- a/drivers/nvdimm/of_pmem.c
>> > +++ b/drivers/nvdimm/of_pmem.c
>> > @@ -31,11 +31,17 @@ static int of_pmem_region_probe(struct platform_device *pdev)
>> >  		return -ENOMEM;
>> >  
>> >  	priv->bus_desc.provider_name = kstrdup(pdev->name, GFP_KERNEL);
>> > +	if (!priv->bus_desc.provider_name) {
>> > +		kfree(priv);
>> > +		return -ENOMEM;
>> > +	}
>> > +
>> >  	priv->bus_desc.module = THIS_MODULE;
>> >  	priv->bus_desc.of_node = np;
>> >  
>> >  	priv->bus = bus = nvdimm_bus_register(&pdev->dev, &priv->bus_desc);
>> >  	if (!bus) {
>> > +		kfree(priv->bus_desc.provider_name);
>> 
>> Nice catch!
>> 
>> However, this free needs to happen in of_pmem_region_remove() as well.
> 
> Looks like the mail from my phone had html in it.  Sorry for that.
> 
> This would be better with devm_kstrdup() and then we don't have to worry
> about the kfree at all.

Looks good.
I have submitted a new patch "libnvdimm/of_pmem: Replace kstrdup with devm_kstrdup and add check".
Since the titie has been modified, I did not submitted a v2.

- Jiasheng Jiang

