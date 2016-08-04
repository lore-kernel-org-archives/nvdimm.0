From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: btt device node disappeared after configure with non support
 sector_size
Date: Thu, 4 Aug 2016 07:37:09 -0700
Message-ID: <CAPcyv4i7o80YuYqpF07YQz4P3RAEYr-NZTLgi53=jMsYEPvOVw@mail.gmail.com>
References: <1128592617.11251323.1470302026839.JavaMail.zimbra@redhat.com>
 <865881147.11251583.1470302147073.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <865881147.11251583.1470302147073.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Aug 4, 2016 at 2:15 AM, Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi folks,
>
> Seems I hit one issue that btt device node disappeared after configure with non support sector_size, could you help confirm it?
>
> 4.7.0
> # ndctl create-namespace -f -e namespace0.0 --mode=sector  -l 512
> {
>   "dev":"namespace0.0",
>   "mode":"sector",
>   "uuid":"45b4900d-da76-47c8-956f-a70e4ea33fe3",
>   "sector_size":512,
>   "blockdev":"pmem0s"
> }
> # lsblk
> NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> pmem0s 259:0    0     8G  0 disk
> pmem1s 259:2    0   7.1G  0 disk
> pmem2s 259:1    0   7.1G  0 disk
> pmem3s 259:3    0   7.1G  0 disk
> # ndctl create-namespace -f -e namespace0.0 --mode=sector  -l 513
> failed to reconfigure namespace
>
> # lsblk
> NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> pmem1s 259:2    0   7.1G  0 disk
> pmem2s 259:1    0   7.1G  0 disk
> pmem3s 259:3    0   7.1G  0 disk

This is expected if you specify invalid namespace values, but we
should be trapping this case and reporting a more useful error message
from ndctl rather than letting the kernel fail the namespace setup.

For now, you can fix this by re-configuring the namespace with valid values.
