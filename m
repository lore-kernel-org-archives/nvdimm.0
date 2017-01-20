From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: mmap dio write failure
Date: Thu, 19 Jan 2017 22:04:01 -0800
Message-ID: <CAPcyv4hO8gEwYHRNRm3n-ZjNzMeW_2x-X-z_09i6wU0DAeFD=A@mail.gmail.com>
References: <20170120044007.kwevjo7nawwolagy@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170120044007.kwevjo7nawwolagy-E9dkjZ7ERC1QcClZ3XN9yxcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-nvdimm <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Thu, Jan 19, 2017 at 8:40 PM, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Hi,
>
> At first, I am not sure whether this is an issue.
>
> mmap a file in a DAX mountpoint, open another file
> in a non-DAX mountpoint with O_DIRECT, write the
> mapped area to the other file.
>
> This write Success on pmem ramdisk(memmap=2G!20G like)
> This write Fail(Bad address) on nvdimm pmem devices.
> This write Fail(Bad address) on brd based ramdisk.
>
> If we skip the O_DIRECT flag, all tests pass.
>
> If we write from DAX to DAX, all tests pass.
> If we write from non-DAX to DAX, all tests pass.
>
> Kernel version: Linus tree commit 44b4b46.
>
> I have checked back to v4.6 testing on nvdimm devices,
> all the same results. I do remember that this test
> passed on nvdimms back to May 2016 and i have some
> notes for that. However things changed a lot, test
> scripts, kernel code, even the nvdimm and machine
> firmweare.
>

This is expected and is the difference between a namespace in "raw"
mode and a namespace in "memory" mode. You can check your namespace's
mode with "ndctl list" (ndctl is packaged in Fedora).

The reason why memmap=ss!nn namespaces work by default is that we
assume they are relatively small and can afford to allocate struct
page in system memory. We don't make the same assumption with
NFIT-defined namespaces. They might be so large that trying to
allocate struct page for them could consume all of system memory. So
you have to convert them into "memory" mode and make a decision at the
time as to whether you want to use a portion of the pmem capacity as
struct page storage, or to go ahead and allocate struct page from
system memory.  By default ndctl will opt to reserve space from pmem
with a command like:

    ndctl create-namespace --reconfig=namespace0.0 --mode=memory --force
