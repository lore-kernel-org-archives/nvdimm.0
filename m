From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [driver-core PATCH v10 0/9] Add NUMA aware async_schedule calls
Date: Thu, 31 Jan 2019 16:17:31 +0100
Message-ID: <20190131151731.GA19261@kroah.com>
References: <154818223154.18753.12374915684623789884.stgit@ahduyck-desk1.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <154818223154.18753.12374915684623789884.stgit-+uVpp3jiz/SWyQ3uPIV3rPooFf0ArEBIu+b9c/7xato@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Alexander Duyck <alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, jiangshanlai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Jan 22, 2019 at 10:39:05AM -0800, Alexander Duyck wrote:
> This patch set provides functionality that will help to improve the
> locality of the async_schedule calls used to provide deferred
> initialization.
> 
> This patch set originally started out focused on just the one call to
> async_schedule_domain in the nvdimm tree that was being used to defer the
> device_add call however after doing some digging I realized the scope of
> this was much broader than I had originally planned. As such I went
> through and reworked the underlying infrastructure down to replacing the
> queue_work call itself with a function of my own and opted to try and
> provide a NUMA aware solution that would work for a broader audience.
> 
> In addition I have added several tweaks and/or clean-ups to the front of the
> patch set. Patches 1 through 3 address a number of issues that actually were
> causing the existing async_schedule calls to not show the performance that
> they could due to either not scaling on a per device basis, or due to issues
> that could result in a potential race. For example, patch 3 addresses the
> fact that we were calling async_schedule once per driver instead of once
> per device, and as a result we would have still ended up with devices
> being probed on a non-local node without addressing this first.
> 
> I have also updated the kernel module used to test async driver probing so
> that it can expose the original issue I was attempting to address.
> It will fail on a system of asynchronous work either takes longer than it
> takes to load a single device and a single driver with a device already
> added. It will also fail if the NUMA node that the driver is loaded on does
> not match the NUMA node the device is associated with.
> 
> RFC->v1:
>     Dropped nvdimm patch to submit later.
>         It relies on code in libnvdimm development tree.
>     Simplified queue_work_near to just convert node into a CPU.
>     Split up drivers core and PM core patches.
> v1->v2:
>     Renamed queue_work_near to queue_work_node
>     Added WARN_ON_ONCE if we use queue_work_node with per-cpu workqueue
> v2->v3:
>     Added Acked-by for queue_work_node patch
>     Continued rename from _near to _node to be consistent with queue_work_node
>         Renamed async_schedule_near_domain to async_schedule_node_domain
>         Renamed async_schedule_near to async_schedule_node
>     Added kerneldoc for new async_schedule_XXX functions
>     Updated patch description for patch 4 to include data on potential gains
> v3->v4
>     Added patch to consolidate use of need_parent_lock
>     Make asynchronous driver probing explicit about use of drvdata
> v4->v5
>     Added patch to move async_synchronize_full to address deadlock
>     Added bit async_probe to act as mutex for probe/remove calls
>     Added back nvdimm patch as code it relies on is now in Linus's tree
>     Incorporated review comments on parent & device locking consolidation
>     Rebased on latest linux-next
> v5->v6:
>     Drop the "This patch" or "This change" from start of patch descriptions.
>     Drop unnecessary parenthesis in first patch
>     Use same wording for "selecting a CPU" in comments added in first patch
>     Added kernel documentation for async_probe member of device
>     Fixed up comments for async_schedule calls in patch 2
>     Moved code related setting async driver out of device.h and into dd.c
>     Added Reviewed-by for several patches
> v6->v7:
>     Fixed typo which had kernel doc refer to "lock" when I meant "unlock"
>     Dropped "bool X:1" to "u8 X:1" from patch description
>     Added async_driver to device_private structure to store driver
>     Dropped unecessary code shuffle from async_probe patch
>     Reordered patches to move fixes up to front
>     Added Reviewed-by for several patches
>     Updated cover page and patch descriptions throughout the set
> v7->v8:
>     Replaced async_probe value with dead, only apply dead in device_del
>     Dropped Reviewed-by from patch 2 due to significant changes
>     Added Reviewed-by for patches reviewed by Luis Chamberlain
> v8->v9:
>     Dropped patch 1 as it was applied, shifted remaining patches by 1
>     Added new patch 9 that adds test framework for NUMA and sequential init
>     Tweaked what is now patch 1, and added Reviewed-by from Dan Williams
> v9->v10:
>     Moved "dead" from device struct to device_private struct
>     Added Reviewed-by from Rafael to patch 1
>     Rebased on latest linux-next

Thanks for sticking with this, now all queued up.

greg k-h
