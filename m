From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] device-dax: fix cdev leak
Date: Thu, 23 Feb 2017 12:27:58 -0800
Message-ID: <CAPcyv4izyvievdZBBjz7nK8Ak+n9yfkTZorwjZxSAAE_S-5gcA@mail.gmail.com>
References: <148787772308.30127.18437190636864555810.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170223202030.GB26301@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170223202030.GB26301-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Feb 23, 2017 at 12:20 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Feb 23, 2017 at 11:22:03AM -0800, Dan Williams wrote:
>> If device_add() fails, cleanup the cdev. Otherwise, we leak a kobj_map()
>> with a stale device number.
>>
>> Fixes: ba09c01d2fa8 ("dax: convert to the cdev api")
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Cc: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
>> Reported-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>> Signed-off-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>  drivers/dax/dax.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
>> index ed758b74ddf0..0f8008dd0b0c 100644
>> +++ b/drivers/dax/dax.c
>> @@ -724,6 +724,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
>>       dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
>>       rc = device_add(dev);
>>       if (rc) {
>> +             cdev_del(&dax_dev->cdev);
>
> This probably should call into unregister_dax_dev and just skip the
> device_unregister part.
>
> Once cdev_add returns it is possible for a mmap to have been created,
> so cleanup after that point has to go through all the other
> unregister_dax_dev steps.

Ah true. I was thinking the device node is not auto-created if the
device_add() fails, but there's theoretically nothing stopping
userspace from trying to hit this race with its own self-created
device-node.
