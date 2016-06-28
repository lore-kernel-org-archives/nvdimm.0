Return-Path: <linux-nvdimm-bounces@lists.01.org>
Subject: Re: [PATCH v5 3/5] um: track 'parent' device in a local variable
References: <146705579255.39775.12551436695635245858.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146705580842.39775.16180359577535598750.stgit@dwillia2-desk3.amr.corp.intel.com>
 <5965be1f-6b0b-d6f7-f6b0-d73b9be87267@sandisk.com>
From: Richard Weinberger <richard@nod.at>
Message-ID: <577231CF.6000301@nod.at>
Date: Tue, 28 Jun 2016 10:14:07 +0200
MIME-Version: 1.0
In-Reply-To: <5965be1f-6b0b-d6f7-f6b0-d73b9be87267@sandisk.com>
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
To: Bart Van Assche <bart.vanassche@sandisk.com>, Dan Williams <dan.j.williams@intel.com>, axboe@fb.com
Cc: linux-block@vger.kernel.org, Jeff Dike <jdike@addtoit.com>, hch@lst.de, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Am 28.06.2016 um 09:23 schrieb Bart Van Assche:
> On 06/27/2016 09:30 PM, Dan Williams wrote:
>> In preparation for the removal of 'driverfs_dev' from 'struct gendisk'
>> use a local variable to track the parented vs un-parented case in
>> ubd_disk_register().
> 
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>

Acked-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
