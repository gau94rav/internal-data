<template>
    <div class="find-me px-3 py-4 rounded-[2px] h-max t-checkbox-group w-72">
		<div class="flex justify-between">
			<div class="relative">
				<span class="filter-header text-base border px-3 py-2 rounded-[2px]">
					<i class="fas fa-filter"></i>
				</span>
				<div class="absolute right-2 bottom-1">
					<div class="circle w-2 h-2 rounded-full"></div>
				</div>
			</div>
			<a class="hover:underline text-xs">Reset</a>
	    </div>
        <!-- <div class="font-bold" v-if="label">
            {{ label.toUpperCase() }}
        </div> -->
        <div
            class="relative px-1 pt-3 overflow-hidden transition"
            :style="{
                maxHeight: containerHeight,
                transition: '0.3s',
            }"
            :class="{ 'w-full': !isInline }"
        >
            <div ref="checkBoxesContainer">
                <t-loading-spinner position="relative" v-if="componentLoading || loading" />
                <div
                    v-show="!componentLoading && !loading"
                    v-for="key in Object.keys(items)"
                    :key="key"
                >
                    <div class="group-label cursor-pointer font-medium text-[#727184] tracking-widest text-sm mt-6">
						<span class="mr-2">
						    <i class="fas fa-angle-down"></i>
						</span>
                        {{ isLabelCapitalized ? key.toUpperCase() : key }}
                    </div>
                    <div class="flex flex-wrap gap-2 ml-6 mr-2 my-3" :class="{ 'flex-col': !isInline }">
                        <div
						    class="input-label text-base font-normal flex justify-between"
                            v-for="value in items[key].data"
                            :key="value.value + '_' + key"
                        >
                            <base-checkbox
                                :label="value.rendered"
                                :value="value.value + '_' + key"
                                v-model="checked"
                                @change="updateUrlParams"
                            />
							<div class="text-base font-normal checkbox-counter">1</div>
                        </div>
                    </div>
                </div>
            </div>
	    </div>
		<!-- Start Show More -->
        <div
            class="mt-2 text-center"
            v-if="!isExpanded && !componentLoading && canBeExpanded"
        >
            <base-button
                v-if="containerHeight !== slotHeight + 'px'"
                ghost
                @click="expand"
                :disabled="componentLoading || loading"
            >
                Show More
            </base-button>
            <base-button
                v-else
                ghost
                @click="collapse"
                :disabled="componentLoading || loading"
            >
                Show Less
            </base-button>
        </div>
		<!-- End Show More -->
    </div>
</template>

<script>
	export default {
		props: {
			label: {
				type: String,
				default: '',
			},
			isExpanded: {
			   type: Boolean,
			   default: false,
			},
			isLabelCapitalized: {
			   type: Boolean,
			   default: false,
			},
			isInline: {
			   type: Boolean,
			   default: false,
			},
			defaultHeight: {
			   type: String,
			   default: '250px',
			}
		},
		data: () => ({
			canBeExpanded: true,
			checked: [],
			containerHeight: "40px",
			items: {},
			is_filter: true,
			componentLoading: true,
			slotHeight: 0,
		}),
		methods: {
			collapse() {
			   this.containerHeight = this.defaultHeight;
			},
			expand() {
			   this.containerHeight = this.slotHeight + 'px';
			},
			getItems() {
				const items = {};
				const keyColumn = this.findColumnByTag('keys');
				const valueColumn = this.findColumnByTag('values');

				for (let row of this.rows) {
					const key = row[keyColumn];
					if (!key) continue;
					if (items[key.value]) {
						items[key.value].data.push(row[valueColumn]);
					} else {
						items[key.value] = { label: '', data: [] }
						items[key.value].label = key.rendered;
						items[key.value].data = [row[valueColumn]];
					}
				}
				this.items = items;
			},
			handleHeight() {
				// Dom gives wrong max height if not delayed.
				setTimeout(() => {
					this.slotHeight = this.$refs.checkBoxesContainer.clientHeight;
					const containerHeight = parseInt(this.defaultHeight.replace(/\D+/g, ''));
					this.canBeExpanded = containerHeight < this.slotHeight;
					return this.containerHeight = this.isExpanded ? this.slotHeight + 'px' : this.defaultHeight;
				}, 100)
			},
			handleInit() {
				this.componentLoading = true;
				const selected = this.getFilterValue("selected_items");
				this.getItems();
				if (selected) {
					this.checked = selected.split('|');
				} else {
				   this.setFilterValue("selected_items", this.checked.join('|'), true);
				}
				this.componentLoading = false;
				this.handleHeight();
			},
			onVisualizationInit() {
				this.handleInit();
			},
			onVisualizationUpdated() {
				this.handleInit();
			},
			updateUrlParams() {
				this.setFilterValue("selected_items", this.checked.join('|'), true);
			},
		}
	}
</script>

<style scoped>
    .t-checkbox-group {
	   box-shadow: inset 0 0 0 1px hsl(244deg 8% 84%);
    }
   body {
		font-family: @import url('https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&display=swap');
	}
    .group-label {
       @apply text-[#727184];
    }
	.input-label {
		@apply text-[#555463];
	}
	.filter-header {
		@apply border-[#d3d3d9];
		@apply text-[#727184];
	}
	.circle {
		background-color: #da7a0b;
	}
	.checkbox-counter {
		@apply text-[#727184];
	}
</style>